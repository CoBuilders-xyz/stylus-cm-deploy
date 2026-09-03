#!/usr/bin/env bash
# Devnode Manager — Lightweight Arbitrum Stylus development node
#
# Runs a single offchainlabs/nitro-node container in --dev mode inside a
# Multipass VM. Much faster than the full testnode (~15s init vs ~10min).
# Time-advance works via VM clock manipulation (same mechanism).
#
# Usage: ./scripts/devnode.sh <command> [args]

set -euo pipefail

# ── Constants ────────────────────────────────────────────────────────────────

VM_NAME="arbitrum-dev"
VM_IMAGE="jammy"
VM_CPUS="${MULTIPASS_VM_CPUS:-1}"
VM_MEMORY="${MULTIPASS_VM_MEMORY:-2G}"
VM_DISK="15G"

NITRO_IMAGE="${NITRO_NODE_IMAGE:-offchainlabs/nitro-node:v3.7.1-926f1ab}"
CONTAINER_NAME="nitro-dev"
DEVNODE_REPO="https://github.com/OffchainLabs/nitro-devnode.git"
DEVNODE_DIR="/home/ubuntu/nitro-devnode"

HOST_RPC_PORT=8547
HOST_WS_PORT=8548

VM_SOCAT_RPC_PORT=18547
VM_SOCAT_WS_PORT=18548

SOCAT_PID_RPC="/tmp/socat-devnode-${HOST_RPC_PORT}.pid"
SOCAT_PID_WS="/tmp/socat-devnode-${HOST_WS_PORT}.pid"

FUNDED_PK="0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659"
FUNDED_ADDR="0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E"

# L2 chain owner from testnode (needs to be funded + made owner in devnode)
L2_OWNER_PK="0xdc04c5399f82306ec4b4d654a342f40e2e0620fe39950d967e1e574b32d4dd36"
L2_OWNER_ADDR="0x5E1497dD1f08C87b2d8FE23e9AAB6c1De833D927"

# Precompile addresses
ARB_DEBUG="0x00000000000000000000000000000000000000FF"
ARB_OWNER="0x0000000000000000000000000000000000000070"

# CacheManager deployment bytecode (from OffchainLabs/nitro-devnode)
CM_BYTECODE="0x60a06040523060805234801561001457600080fd5b50608051611d1c61003060003960006105260152611d1c6000f3fe"

# CREATE2 factory deployer (EIP-2470 standard)
CREATE2_FACTORY="0x4e59b44847b379578588920ca78fbf26c0b4956c"
CREATE2_DEPLOYER_ADDR="0x3fab184622dc19b6109349b94811493bf2a45362"
CREATE2_TX="0xf8a58085174876e800830186a08080b853604580600e600039806000f350fe7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe03601600081602082378035828234f58015156039578182fd5b8082525050506014600cf31ba02222222222222222222222222222222222222222222222222222222222222222a02222222222222222222222222222222222222222222222222222222222222222"

ADDRESSES_FILE="/tmp/devnode-addresses.env"

# ── Helpers ──────────────────────────────────────────────────────────────────

log()  { echo "==> $*"; }
warn() { echo "WARN: $*" >&2; }
die()  { echo "ERROR: $*" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Required command not found: $1"
}

vm_exists() {
  multipass info "$VM_NAME" >/dev/null 2>&1
}

vm_is_running() {
  local state
  state=$(multipass info "$VM_NAME" --format json 2>/dev/null \
    | jq -r ".info.\"${VM_NAME}\".state" 2>/dev/null || echo "")
  [[ "$state" == "Running" ]]
}

get_vm_ip() {
  multipass info "$VM_NAME" --format json 2>/dev/null \
    | jq -r ".info.\"${VM_NAME}\".ipv4[0]" 2>/dev/null || echo ""
}

run_in_vm() {
  multipass exec "$VM_NAME" -- bash -lc "$1"
}

ensure_vm_running() {
  if ! vm_exists; then
    die "VM '$VM_NAME' does not exist. Run '$0 setup' first."
  fi
  if ! vm_is_running; then
    log "Starting VM '$VM_NAME'..."
    multipass start "$VM_NAME"
    sleep 3
  fi
}

port_in_use() {
  ss -tlnp 2>/dev/null | grep -q ":${1} " && return 0
  return 1
}

start_socat() {
  local local_port="$1" remote_ip="$2" remote_port="$3" pid_file="$4"
  stop_socat "$pid_file"
  if port_in_use "$local_port"; then
    die "Port $local_port already in use on host."
  fi
  log "socat: localhost:${local_port} -> ${remote_ip}:${remote_port}"
  socat "TCP-LISTEN:${local_port},fork,reuseaddr,bind=0.0.0.0" \
        "TCP:${remote_ip}:${remote_port}" &
  echo "$!" > "$pid_file"
  disown "$!" 2>/dev/null || true
}

stop_socat() {
  local pid_file="$1"
  if [[ -f "$pid_file" ]]; then
    local pid
    pid=$(cat "$pid_file" 2>/dev/null || echo "")
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
    fi
    rm -f "$pid_file"
  fi
}

socat_is_running() {
  local pid_file="$1"
  if [[ -f "$pid_file" ]]; then
    local pid
    pid=$(cat "$pid_file" 2>/dev/null || echo "")
    [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null && return 0
  fi
  return 1
}

send_dummy_tx() {
  local rpc_url="${1:-http://localhost:${HOST_RPC_PORT}}"
  if command -v cast >/dev/null 2>&1; then
    cast send "$FUNDED_ADDR" --value 0 --private-key "$FUNDED_PK" \
      --rpc-url "$rpc_url" >/dev/null 2>&1 || true
  fi
}

wait_for_rpc() {
  local retries=60
  while ! run_in_vm "curl -sf http://127.0.0.1:8547 -X POST \
    -H 'Content-Type: application/json' \
    -d '{\"jsonrpc\":\"2.0\",\"method\":\"net_version\",\"params\":[],\"id\":1}'" >/dev/null 2>&1; do
    retries=$((retries - 1))
    if [[ $retries -le 0 ]]; then
      die "Node did not start in 30s"
    fi
    sleep 0.5
  done
}

# ── Commands ─────────────────────────────────────────────────────────────────

cmd_setup() {
  require_cmd multipass
  require_cmd jq

  log "Setting up devnode VM '$VM_NAME'..."

  if ! vm_exists; then
    log "Creating VM: cpus=$VM_CPUS memory=$VM_MEMORY disk=$VM_DISK"
    multipass launch \
      --name "$VM_NAME" \
      --cpus "$VM_CPUS" \
      --memory "$VM_MEMORY" \
      --disk "$VM_DISK" \
      "$VM_IMAGE"
  else
    log "VM '$VM_NAME' already exists"
  fi

  if ! vm_is_running; then
    multipass start "$VM_NAME"
    sleep 3
  fi

  log "Installing base packages..."
  run_in_vm "sudo apt-get update -qq"
  run_in_vm "sudo apt-get install -y -qq ca-certificates curl git gnupg jq socat > /dev/null"

  log "Installing Docker..."
  run_in_vm '
if ! command -v docker >/dev/null 2>&1; then
  sudo install -m 0755 -d /etc/apt/keyrings
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  source /etc/os-release
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update -qq
  sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io \
    docker-buildx-plugin docker-compose-plugin > /dev/null
fi
sudo usermod -aG docker ubuntu
'

  log "Installing Foundry (cast)..."
  run_in_vm '
if ! command -v ~/.foundry/bin/cast >/dev/null 2>&1; then
  curl -L https://foundry.paradigm.xyz 2>/dev/null | bash 2>/dev/null
  ~/.foundry/bin/foundryup 2>&1 | tail -1
fi
'

  log "Cloning nitro-devnode (for StylusDeployer bytecode)..."
  run_in_vm "
if [ ! -d '${DEVNODE_DIR}/.git' ]; then
  git clone '${DEVNODE_REPO}' '${DEVNODE_DIR}'
else
  cd '${DEVNODE_DIR}' && git pull --ff-only || true
fi
"

  log "Pulling nitro-node image..."
  run_in_vm "sg docker -c 'docker pull ${NITRO_IMAGE}'"

  local vm_ip
  vm_ip=$(get_vm_ip)

  log "Setup complete!"
  echo ""
  echo "  VM:    $VM_NAME ($vm_ip)"
  echo "  Image: $NITRO_IMAGE"
  echo ""
  echo "Next: $0 init"
}

cmd_init() {
  require_cmd multipass
  ensure_vm_running

  log "Initializing devnode (this resets chain state)..."

  # Remove any existing container
  run_in_vm "sg docker -c 'docker rm -f ${CONTAINER_NAME}'" 2>/dev/null || true

  # Start nitro-node in dev mode
  log "Starting nitro-node container..."
  run_in_vm "sg docker -c 'docker run -d \
    --name ${CONTAINER_NAME} \
    -p 8547:8547 \
    -p 8548:8548 \
    ${NITRO_IMAGE} \
    --dev \
    --http.addr 0.0.0.0 \
    --http.vhosts=* \
    --http.corsdomain=* \
    --http.api=net,web3,eth,debug \
    --ws.addr 0.0.0.0 \
    --ws.api=net,web3,eth,debug'"

  log "Waiting for node..."
  wait_for_rpc

  local CAST="\$HOME/.foundry/bin/cast"
  local RPC="http://127.0.0.1:8547"

  # 1. Become chain owner (funded account)
  log "Setting chain ownership..."
  run_in_vm "${CAST} send ${ARB_DEBUG} 'becomeChainOwner()' \
    --private-key ${FUNDED_PK} --rpc-url ${RPC}" >/dev/null

  # 1b. Fund and make L2 owner a chain owner too (used by integration tests)
  log "Funding L2 owner account..."
  run_in_vm "${CAST} send ${L2_OWNER_ADDR} --value '100 ether' \
    --private-key ${FUNDED_PK} --rpc-url ${RPC}" >/dev/null
  run_in_vm "${CAST} send ${ARB_DEBUG} 'becomeChainOwner()' \
    --private-key ${L2_OWNER_PK} --rpc-url ${RPC}" >/dev/null

  # 2. Set L1 data fee to 0 (allows larger deployments)
  run_in_vm "${CAST} send --rpc-url ${RPC} --private-key ${FUNDED_PK} \
    ${ARB_OWNER} 'setL1PricePerUnit(uint256)' 0x0" >/dev/null

  # 3. Deploy CREATE2 factory
  log "Deploying CREATE2 factory..."
  run_in_vm "${CAST} send --rpc-url ${RPC} --private-key ${FUNDED_PK} \
    --value '1 ether' ${CREATE2_DEPLOYER_ADDR}" >/dev/null
  run_in_vm "${CAST} publish --rpc-url ${RPC} ${CREATE2_TX}" >/dev/null

  # 4. Deploy CacheManager
  log "Deploying CacheManager..."
  local cm_output
  cm_output=$(run_in_vm "${CAST} send --private-key ${FUNDED_PK} \
    --rpc-url ${RPC} --create ${CM_BYTECODE}" 2>&1)
  local cm_address
  cm_address=$(echo "$cm_output" | awk '/contractAddress/ {print $2}')

  if [[ -z "$cm_address" ]]; then
    die "Failed to deploy CacheManager. Output:\n$cm_output"
  fi

  # 5. Register CacheManager as WASM cache manager
  log "Registering CacheManager..."
  run_in_vm "${CAST} send --private-key ${FUNDED_PK} --rpc-url ${RPC} \
    ${ARB_OWNER} 'addWasmCacheManager(address)' ${cm_address}" >/dev/null

  # 6. Deploy StylusDeployer (needed by cargo-stylus deploy)
  log "Deploying StylusDeployer..."
  local deployer_code
  deployer_code=$(run_in_vm "cat ${DEVNODE_DIR}/stylus-deployer-bytecode.txt")
  local deployer_addr
  deployer_addr=$(run_in_vm "${CAST} create2 \
    --salt 0x0000000000000000000000000000000000000000000000000000000000000000 \
    --init-code ${deployer_code}")
  run_in_vm "${CAST} send --private-key ${FUNDED_PK} --rpc-url ${RPC} \
    ${CREATE2_FACTORY} \
    '0x0000000000000000000000000000000000000000000000000000000000000000${deployer_code#0x}'" >/dev/null 2>&1 || true

  # Save addresses
  echo "CACHE_MANAGER_ADDRESS=${cm_address}" > "$ADDRESSES_FILE"
  echo "STYLUS_DEPLOYER_ADDRESS=${deployer_addr}" >> "$ADDRESSES_FILE"

  log "Devnode initialized!"
  echo ""
  echo "  CacheManager:    $cm_address"
  echo "  StylusDeployer:  $deployer_addr"
  echo "  Chain ID:        412346"
  echo "  Funded account:  $FUNDED_ADDR"
  echo ""
  echo "Next: $0 start   # set up port forwarding"
}

cmd_start() {
  require_cmd multipass
  require_cmd socat
  require_cmd jq

  ensure_vm_running

  local vm_ip
  vm_ip=$(get_vm_ip)
  if [[ -z "$vm_ip" ]]; then
    die "Could not determine VM IP."
  fi
  log "VM IP: $vm_ip"

  # Start container if stopped (chain state is lost on restart — re-init if needed)
  local container_running
  container_running=$(run_in_vm "sg docker -c 'docker inspect -f {{.State.Running}} ${CONTAINER_NAME}'" 2>/dev/null || echo "false")

  if [[ "$container_running" != "true" ]]; then
    log "Container not running. Starting..."
    run_in_vm "sg docker -c 'docker start ${CONTAINER_NAME}'" 2>/dev/null || {
      warn "Container doesn't exist. Run '$0 init' first."
      return 1
    }
    wait_for_rpc
  fi

  # Wait for sequencer inside VM
  log "Waiting for RPC inside VM..."
  wait_for_rpc

  # Setup socat inside VM (0.0.0.0 -> 127.0.0.1)
  log "Setting up socat..."
  multipass exec "$VM_NAME" -- pkill -f "socat TCP-LISTEN:${VM_SOCAT_RPC_PORT}" 2>/dev/null || true
  multipass exec "$VM_NAME" -- pkill -f "socat TCP-LISTEN:${VM_SOCAT_WS_PORT}" 2>/dev/null || true
  sleep 1
  multipass exec "$VM_NAME" -- socat "TCP-LISTEN:${VM_SOCAT_RPC_PORT},fork,reuseaddr,bind=0.0.0.0" "TCP:127.0.0.1:${HOST_RPC_PORT}" &
  disown $! 2>/dev/null || true
  multipass exec "$VM_NAME" -- socat "TCP-LISTEN:${VM_SOCAT_WS_PORT},fork,reuseaddr,bind=0.0.0.0" "TCP:127.0.0.1:${HOST_WS_PORT}" &
  disown $! 2>/dev/null || true
  sleep 1

  # Host socat (host:8547 -> vm:18547)
  start_socat "$HOST_RPC_PORT" "$vm_ip" "$VM_SOCAT_RPC_PORT" "$SOCAT_PID_RPC"
  start_socat "$HOST_WS_PORT"  "$vm_ip" "$VM_SOCAT_WS_PORT"  "$SOCAT_PID_WS"

  sleep 1
  log "Verifying connectivity..."
  local chain_id
  chain_id=$(curl -sf "http://localhost:${HOST_RPC_PORT}" \
    -X POST -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' \
    | jq -r '.result' 2>/dev/null || echo "failed")

  if [[ "$chain_id" == "failed" || -z "$chain_id" ]]; then
    warn "Could not verify RPC connectivity."
  else
    log "Connected! Chain ID: $((chain_id))"
  fi

  echo ""
  echo "Devnode is running:"
  echo "  HTTP RPC:  http://localhost:${HOST_RPC_PORT}"
  echo "  WebSocket: ws://localhost:${HOST_WS_PORT}"
  echo ""
}

cmd_stop() {
  log "Stopping port forwarding..."
  stop_socat "$SOCAT_PID_RPC"
  stop_socat "$SOCAT_PID_WS"

  if vm_exists && vm_is_running; then
    log "Stopping VM socat..."
    multipass exec "$VM_NAME" -- pkill -f "socat TCP-LISTEN:${VM_SOCAT_RPC_PORT}" 2>/dev/null || true
    multipass exec "$VM_NAME" -- pkill -f "socat TCP-LISTEN:${VM_SOCAT_WS_PORT}" 2>/dev/null || true

    log "Stopping container..."
    run_in_vm "sg docker -c 'docker stop ${CONTAINER_NAME}'" 2>/dev/null || true
  fi

  log "Stopped."
}

cmd_status() {
  echo "=== Devnode Status ==="
  echo ""

  if ! vm_exists; then
    echo "VM:        not created (run: $0 setup)"
    return
  fi

  if vm_is_running; then
    local vm_ip
    vm_ip=$(get_vm_ip)
    echo "VM:        Running ($vm_ip)"
  else
    echo "VM:        Stopped (run: $0 start)"
    return
  fi

  local container_running
  container_running=$(run_in_vm "sg docker -c 'docker inspect -f {{.State.Running}} ${CONTAINER_NAME}'" 2>/dev/null || echo "false")
  echo "Container: $container_running"

  echo ""
  echo "--- Connectivity ---"
  local chain_id
  chain_id=$(curl -sf "http://localhost:${HOST_RPC_PORT}" \
    -X POST -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' \
    2>/dev/null | jq -r '.result' 2>/dev/null || echo "")

  if [[ -n "$chain_id" ]]; then
    echo "RPC:       OK (chain ID: $((chain_id)))"
  else
    echo "RPC:       NOT REACHABLE"
  fi

  echo ""
  echo "--- VM Clock ---"
  local vm_time
  vm_time=$(run_in_vm "date -u '+%Y-%m-%d %H:%M:%S UTC'" 2>/dev/null || echo "unknown")
  echo "VM time:   $vm_time"
  echo "Host time: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"

  if [[ -f "$ADDRESSES_FILE" ]]; then
    echo ""
    echo "--- Addresses ---"
    cat "$ADDRESSES_FILE"
  fi
}

cmd_destroy() {
  log "Destroying VM '$VM_NAME'..."
  stop_socat "$SOCAT_PID_RPC"
  stop_socat "$SOCAT_PID_WS"
  if vm_exists; then
    multipass delete "$VM_NAME" --purge
  fi
  rm -f "$ADDRESSES_FILE"
  log "Destroyed."
}

cmd_time_advance() {
  local hours="${1:-}"
  if [[ -z "$hours" ]]; then
    die "Usage: $0 time-advance <hours>"
  fi

  require_cmd multipass
  ensure_vm_running

  log "Disabling NTP in VM..."
  run_in_vm "sudo timedatectl set-ntp false" 2>/dev/null || true

  log "Advancing VM clock by ${hours} hours..."
  run_in_vm "sudo date -s '+${hours} hours'"

  local vm_time
  vm_time=$(run_in_vm "date -u '+%Y-%m-%d %H:%M:%S UTC'" 2>/dev/null || echo "unknown")
  log "VM time is now: $vm_time"

  log "Sending dummy tx to produce a block with new timestamp..."
  send_dummy_tx "http://localhost:${HOST_RPC_PORT}"

  log "Time advanced by ${hours} hours."
}

cmd_time_reset() {
  require_cmd multipass
  ensure_vm_running

  log "Re-enabling NTP and syncing VM clock..."
  run_in_vm "sudo timedatectl set-ntp true"
  sleep 3

  local vm_time
  vm_time=$(run_in_vm "date -u '+%Y-%m-%d %H:%M:%S UTC'" 2>/dev/null || echo "unknown")
  log "VM time is now: $vm_time"

  # Restart the container so it picks up the new clock
  log "Restarting container..."
  run_in_vm "sg docker -c 'docker restart ${CONTAINER_NAME}'" 2>/dev/null || true

  log "Waiting for node..."
  wait_for_rpc

  log "Sending dummy tx..."
  send_dummy_tx "http://localhost:${HOST_RPC_PORT}"

  log "Time reset complete."
}

cmd_shell() {
  require_cmd multipass
  ensure_vm_running
  multipass shell "$VM_NAME"
}

# ── Usage ────────────────────────────────────────────────────────────────────

usage() {
  cat <<EOF
Devnode Manager — Lightweight Arbitrum Stylus development node

Runs a single offchainlabs/nitro-node container in --dev mode inside a
Multipass VM. Includes CacheManager, ArbWasm, and all Stylus precompiles.
Time-advance works via VM clock manipulation.

Usage: $0 <command> [args]

Commands:
  setup                Create VM, install Docker/Foundry, pull image
  init                 Start devnode + deploy contracts (~15 sec)
  start                Port forwarding (after VM restart)
  stop                 Stop devnode + port forwarding
  status               Show status
  destroy              Delete the VM
  time-advance <hrs>   Advance VM clock by N hours
  time-reset           Sync VM clock back to real time
  shell                Open a shell in the VM

Workflow:
  $0 setup        # Once (~3 min)
  $0 init         # Each time you need a fresh chain (~15 sec)
  $0 start        # Port forwarding

Testing activations:
  $0 time-advance 25
  $0 time-reset
EOF
}

# ── Main ─────────────────────────────────────────────────────────────────────

main() {
  local cmd="${1:-}"
  shift || true

  case "$cmd" in
    setup)         cmd_setup ;;
    init)          cmd_init ;;
    start)         cmd_start ;;
    stop)          cmd_stop ;;
    status)        cmd_status ;;
    destroy)       cmd_destroy ;;
    time-advance)  cmd_time_advance "$@" ;;
    time-reset)    cmd_time_reset ;;
    shell)         cmd_shell ;;
    -h|--help|help|"")
      usage
      ;;
    *)
      die "Unknown command: $cmd. Run '$0 --help' for usage."
      ;;
  esac
}

main "$@"
