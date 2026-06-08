#!/usr/bin/env bash
# Multipass Testnode Manager
#
# Manages a nitro-testnode running inside a Multipass VM with transparent
# port forwarding via socat on the host. The testnode is reachable at
# localhost:8547 (HTTP) and localhost:8548 (WS), identical to a host-run node.
#
# Usage: ./scripts/multipass-testnode.sh <command> [args]

set -euo pipefail

# ── Constants ────────────────────────────────────────────────────────────────

VM_NAME="arbitrum-test"
VM_IMAGE="jammy"
VM_CPUS="2"
VM_MEMORY="3G"
VM_DISK="30G"

NITRO_DIR="/home/ubuntu/nitro-testnode"
NITRO_REPO="https://github.com/OffchainLabs/nitro-testnode.git"
NITRO_BRANCH="release"

HOST_RPC_PORT=8547
HOST_WS_PORT=8548

# Ports socat listens on inside the VM (forwarding 0.0.0.0 -> 127.0.0.1)
VM_SOCAT_RPC_PORT=18547
VM_SOCAT_WS_PORT=18548

SOCAT_PID_RPC="/tmp/socat-testnode-${HOST_RPC_PORT}.pid"
SOCAT_PID_WS="/tmp/socat-testnode-${HOST_WS_PORT}.pid"

# Prefunded nitro testnode wallet (for dummy txs)
FUNDED_PK="0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659"
FUNDED_ADDR="0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E"

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

# Check if a local port is already in use
port_in_use() {
  local port="$1"
  ss -tlnp 2>/dev/null | grep -q ":${port} " && return 0
  return 1
}

# Start a socat forwarder on the host
start_socat() {
  local local_port="$1"
  local remote_ip="$2"
  local remote_port="$3"
  local pid_file="$4"

  stop_socat "$pid_file"

  if port_in_use "$local_port"; then
    die "Port $local_port is already in use on the host. Stop the process using it first (e.g. a host-run testnode)."
  fi

  log "Starting socat: localhost:${local_port} -> ${remote_ip}:${remote_port}"
  socat "TCP-LISTEN:${local_port},fork,reuseaddr,bind=0.0.0.0" \
        "TCP:${remote_ip}:${remote_port}" &
  local pid=$!
  echo "$pid" > "$pid_file"
  disown "$pid" 2>/dev/null || true
}

# Stop a socat forwarder by PID file
stop_socat() {
  local pid_file="$1"
  if [[ -f "$pid_file" ]]; then
    local pid
    pid=$(cat "$pid_file" 2>/dev/null || echo "")
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
      wait "$pid" 2>/dev/null || true
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

# Send a dummy tx to force a new block (uses curl raw RPC, no cast needed)
send_dummy_tx() {
  local rpc_url="${1:-http://localhost:${HOST_RPC_PORT}}"
  if command -v cast >/dev/null 2>&1; then
    cast send "$FUNDED_ADDR" \
      --value 0 \
      --private-key "$FUNDED_PK" \
      --rpc-url "$rpc_url" \
      >/dev/null 2>&1 || true
  else
    warn "cast not found; sending a no-op RPC call instead. Install foundry for full time-advance support."
    curl -s -X POST "$rpc_url" \
      -H "Content-Type: application/json" \
      -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
      >/dev/null 2>&1 || true
  fi
}

# ── Commands ─────────────────────────────────────────────────────────────────

cmd_setup() {
  require_cmd multipass
  require_cmd jq

  log "Setting up VM '$VM_NAME'..."

  # Create VM if it doesn't exist
  if ! vm_exists; then
    log "Creating VM: cpus=$VM_CPUS memory=$VM_MEMORY disk=$VM_DISK image=$VM_IMAGE"
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

  log "Installing Docker (if needed)..."
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
  echo "Docker installed"
else
  echo "Docker already installed"
fi
sudo usermod -aG docker ubuntu
'

  log "Cloning nitro-testnode (branch: $NITRO_BRANCH)..."
  run_in_vm "
if [ ! -d '${NITRO_DIR}/.git' ]; then
  git clone -b '${NITRO_BRANCH}' --recurse-submodules '${NITRO_REPO}' '${NITRO_DIR}'
else
  echo 'nitro-testnode already cloned, updating...'
  git -C '${NITRO_DIR}' fetch origin '${NITRO_BRANCH}'
  git -C '${NITRO_DIR}' checkout '${NITRO_BRANCH}'
  git -C '${NITRO_DIR}' pull --ff-only origin '${NITRO_BRANCH}' || true
  git -C '${NITRO_DIR}' submodule update --init --recursive
fi
"

  local vm_ip
  vm_ip=$(get_vm_ip)

  log "Setup complete!"
  echo ""
  echo "  VM:    $VM_NAME"
  echo "  IP:    $vm_ip"
  echo "  Node:  $NITRO_DIR"
  echo ""
  echo "Next steps:"
  echo "  $0 init     # Initialize chain state (first time only)"
  echo "  $0 start    # Start testnode + port forwarding"
}

cmd_init() {
  require_cmd multipass

  ensure_vm_running

  log "Initializing nitro-testnode (this will reset chain state)..."

  if [[ "${SKIP_CONFIRM:-}" != "1" ]]; then
    echo ""
    echo "WARNING: This destroys any existing chain data in the VM."
    echo "Press Ctrl+C within 5 seconds to abort."
    sleep 5
  fi

  # --init already starts the node. --detach runs it in the background.
  run_in_vm "cd '${NITRO_DIR}' && sg docker -c './test-node.bash --init --detach'"

  log "Testnode initialized and running inside VM."
  echo ""
  echo "Next: $0 start   # to set up port forwarding"
}

cmd_start() {
  require_cmd multipass
  require_cmd socat
  require_cmd jq

  ensure_vm_running

  local vm_ip
  vm_ip=$(get_vm_ip)
  if [[ -z "$vm_ip" ]]; then
    die "Could not determine VM IP address."
  fi

  log "VM IP: $vm_ip"

  # Start testnode containers if not running.
  # --pull never: blockscout-testnode is built locally during init and can't be pulled.
  log "Ensuring testnode containers are running..."
  run_in_vm "cd '${NITRO_DIR}' && sg docker -c 'docker compose up -d --pull never'" || true

  # Wait for sequencer to be reachable inside the VM
  log "Waiting for sequencer to be reachable inside VM..."
  local retries=30
  while ! run_in_vm "curl -sf http://127.0.0.1:${HOST_RPC_PORT} -X POST -H 'Content-Type: application/json' -d '{\"jsonrpc\":\"2.0\",\"method\":\"eth_chainId\",\"params\":[],\"id\":1}'" >/dev/null 2>&1; do
    retries=$((retries - 1))
    if [[ $retries -le 0 ]]; then
      die "Sequencer not reachable inside VM after 60s. Check: $0 shell"
    fi
    sleep 2
  done

  # The sequencer binds to 127.0.0.1 inside the VM (Docker default for
  # nitro-testnode). We need socat inside the VM to expose the ports on
  # 0.0.0.0 so the host can reach them via the VM's IP.
  log "Setting up socat inside VM (0.0.0.0 -> 127.0.0.1)..."
  multipass exec "$VM_NAME" -- pkill -f "socat TCP-LISTEN:${VM_SOCAT_RPC_PORT}" 2>/dev/null || true
  multipass exec "$VM_NAME" -- pkill -f "socat TCP-LISTEN:${VM_SOCAT_WS_PORT}" 2>/dev/null || true
  sleep 1
  multipass exec "$VM_NAME" -- socat "TCP-LISTEN:${VM_SOCAT_RPC_PORT},fork,reuseaddr,bind=0.0.0.0" "TCP:127.0.0.1:${HOST_RPC_PORT}" &
  disown $! 2>/dev/null || true
  multipass exec "$VM_NAME" -- socat "TCP-LISTEN:${VM_SOCAT_WS_PORT},fork,reuseaddr,bind=0.0.0.0" "TCP:127.0.0.1:${HOST_WS_PORT}" &
  disown $! 2>/dev/null || true
  sleep 1

  # Verify VM socat is working
  if ! curl -sf "http://${vm_ip}:${VM_SOCAT_RPC_PORT}" -X POST -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' >/dev/null 2>&1; then
    warn "VM socat not responding on port ${VM_SOCAT_RPC_PORT}. Retrying..."
    sleep 2
  fi

  # Start socat port forwarding on the host (host:8547 -> vm:18547, etc.)
  start_socat "$HOST_RPC_PORT" "$vm_ip" "$VM_SOCAT_RPC_PORT" "$SOCAT_PID_RPC"
  start_socat "$HOST_WS_PORT"  "$vm_ip" "$VM_SOCAT_WS_PORT"  "$SOCAT_PID_WS"

  # Verify connectivity from host
  sleep 1
  log "Verifying connectivity..."
  local chain_id
  chain_id=$(curl -sf "http://localhost:${HOST_RPC_PORT}" \
    -X POST -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' \
    | jq -r '.result' 2>/dev/null || echo "failed")

  if [[ "$chain_id" == "failed" || -z "$chain_id" ]]; then
    warn "Could not verify RPC connectivity. Check the sequencer status."
  else
    local decimal_id=$((chain_id))
    log "Connected! Chain ID: $decimal_id (${chain_id})"
  fi

  echo ""
  echo "Testnode is running:"
  echo "  HTTP RPC:  http://localhost:${HOST_RPC_PORT}"
  echo "  WebSocket: ws://localhost:${HOST_WS_PORT}"
  echo "  VM IP:     $vm_ip"
  echo ""
  echo "These URLs work for:"
  echo "  - Host tools (cast, hardhat, jest):  localhost:${HOST_RPC_PORT}"
  echo "  - Docker containers:                 host.docker.internal:${HOST_RPC_PORT}"
}

cmd_stop() {
  log "Stopping host port forwarding..."
  stop_socat "$SOCAT_PID_RPC"
  stop_socat "$SOCAT_PID_WS"

  if vm_exists && vm_is_running; then
    log "Stopping VM socat forwarders..."
    multipass exec "$VM_NAME" -- pkill -f "socat TCP-LISTEN:${VM_SOCAT_RPC_PORT}" 2>/dev/null || true
    multipass exec "$VM_NAME" -- pkill -f "socat TCP-LISTEN:${VM_SOCAT_WS_PORT}" 2>/dev/null || true

    log "Stopping testnode containers inside VM..."
    run_in_vm "cd '${NITRO_DIR}' && sg docker -c 'docker compose down'" 2>/dev/null || true
  fi

  log "Stopped."
}

cmd_status() {
  echo "=== Multipass Testnode Status ==="
  echo ""

  # VM status
  if ! vm_exists; then
    echo "VM:        not created (run: $0 setup)"
    return
  fi

  if vm_is_running; then
    local vm_ip
    vm_ip=$(get_vm_ip)
    echo "VM:        Running"
    echo "VM IP:     $vm_ip"
  else
    echo "VM:        Stopped (run: $0 start)"
    return
  fi

  # Testnode containers
  echo ""
  echo "--- Testnode Containers ---"
  local container_count
  container_count=$(run_in_vm "sg docker -c 'docker compose -f ${NITRO_DIR}/docker-compose.yaml ps -q 2>/dev/null | wc -l'" 2>/dev/null || echo "0")
  container_count=$(echo "$container_count" | tr -d '[:space:]')

  if [[ "$container_count" -gt 0 ]]; then
    local running_count
    running_count=$(run_in_vm "sg docker -c 'docker compose -f ${NITRO_DIR}/docker-compose.yaml ps --status running -q 2>/dev/null | wc -l'" 2>/dev/null || echo "0")
    running_count=$(echo "$running_count" | tr -d '[:space:]')
    echo "Containers: $running_count running / $container_count total"
  else
    echo "Containers: none (run: $0 init)"
  fi

  # socat status
  echo ""
  echo "--- Port Forwarding (socat) ---"
  if socat_is_running "$SOCAT_PID_RPC"; then
    echo "RPC  :${HOST_RPC_PORT}  -> VM:${HOST_RPC_PORT}   [ACTIVE]"
  else
    echo "RPC  :${HOST_RPC_PORT}  -> VM:${HOST_RPC_PORT}   [INACTIVE]"
  fi
  if socat_is_running "$SOCAT_PID_WS"; then
    echo "WS   :${HOST_WS_PORT}  -> VM:${HOST_WS_PORT}   [ACTIVE]"
  else
    echo "WS   :${HOST_WS_PORT}  -> VM:${HOST_WS_PORT}   [INACTIVE]"
  fi

  # Connectivity check
  echo ""
  echo "--- Connectivity ---"
  local chain_id
  chain_id=$(curl -sf "http://localhost:${HOST_RPC_PORT}" \
    -X POST -H "Content-Type: application/json" \
    -d '{"jsonrpc":"2.0","method":"eth_chainId","params":[],"id":1}' \
    2>/dev/null | jq -r '.result' 2>/dev/null || echo "")

  if [[ -n "$chain_id" ]]; then
    local decimal_id=$((chain_id))
    echo "RPC:       OK (chain ID: $decimal_id)"
  else
    echo "RPC:       NOT REACHABLE"
  fi

  # VM time
  echo ""
  echo "--- VM Clock ---"
  local vm_time
  vm_time=$(run_in_vm "date -u '+%Y-%m-%d %H:%M:%S UTC'" 2>/dev/null || echo "unknown")
  local host_time
  host_time=$(date -u '+%Y-%m-%d %H:%M:%S UTC')
  echo "VM time:   $vm_time"
  echo "Host time: $host_time"
}

cmd_destroy() {
  log "Destroying VM '$VM_NAME'..."

  # Stop socat first
  stop_socat "$SOCAT_PID_RPC"
  stop_socat "$SOCAT_PID_WS"

  if vm_exists; then
    if vm_is_running; then
      log "Stopping testnode containers..."
      run_in_vm "cd '${NITRO_DIR}' && sg docker -c 'docker compose down'" 2>/dev/null || true
    fi
    log "Deleting VM..."
    multipass delete "$VM_NAME" --purge
  else
    log "VM does not exist."
  fi

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

  log "Sending dummy tx to produce a block with the new timestamp..."
  send_dummy_tx "http://localhost:${HOST_RPC_PORT}"

  log "Time advanced by ${hours} hours."
}

cmd_time_reset() {
  require_cmd multipass
  ensure_vm_running

  log "Re-enabling NTP and syncing VM clock..."
  run_in_vm "sudo timedatectl set-ntp true"

  # Give systemd-timesyncd a moment to re-sync
  sleep 3

  local vm_time
  vm_time=$(run_in_vm "date -u '+%Y-%m-%d %H:%M:%S UTC'" 2>/dev/null || echo "unknown")
  log "VM time is now: $vm_time"

  # Restart testnode containers so geth/sequencer pick up the corrected clock.
  # Without this, geth keeps producing L1 blocks with "future" timestamps from
  # the previous time-advance, and the sequencer refuses to sequence because
  # "L1 timestamp too far from local clock time".
  log "Restarting testnode containers to sync chain clock..."
  run_in_vm "cd '${NITRO_DIR}' && sg docker -c 'docker compose restart'" 2>/dev/null || true

  # Wait for sequencer to come back
  log "Waiting for sequencer to be reachable..."
  local retries=30
  while ! run_in_vm "curl -sf http://127.0.0.1:${HOST_RPC_PORT} -X POST -H 'Content-Type: application/json' -d '{\"jsonrpc\":\"2.0\",\"method\":\"eth_chainId\",\"params\":[],\"id\":1}'" >/dev/null 2>&1; do
    retries=$((retries - 1))
    if [[ $retries -le 0 ]]; then
      warn "Sequencer not reachable after restart. The chain may need reinit."
      break
    fi
    sleep 2
  done

  log "Sending dummy tx to propagate the reset timestamp..."
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
Multipass Testnode Manager

Manages a nitro-testnode inside a Multipass VM with transparent port
forwarding. The testnode is reachable at localhost:8547/8548.

Usage: $0 <command> [args]

Commands:
  setup                Create VM, install Docker, clone nitro-testnode
  init                 Initialize chain state (destructive, first-time setup)
  start                Start testnode + port forwarding (day-to-day)
  stop                 Stop testnode + port forwarding
  status               Show VM, testnode, and connectivity status
  destroy              Delete the VM entirely
  time-advance <hrs>   Advance VM clock by N hours (for expiry testing)
  time-reset           Sync VM clock back to real time
  shell                Open an interactive shell in the VM

Typical first-time workflow:
  $0 setup        # Create VM + install deps (once)
  $0 init         # Initialize chain (once, or to reset)
  $0 start        # Start testnode + forwarding

Day-to-day:
  $0 start        # Start
  $0 stop         # Stop
  $0 status       # Check everything

Testing activations:
  $0 time-advance 25   # Jump 25 hours
  $0 time-reset        # Back to real time
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
