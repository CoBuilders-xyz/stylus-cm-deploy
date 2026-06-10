#!/usr/bin/env bash
# Setup ThirdWeb Engine for local development.
#
# Creates an access token, imports the funded wallet, and updates
# .env.backend so the backend can authenticate with Engine.
#
# Usage: ./scripts/setup-engine.sh
#
# Idempotent: safe to run multiple times (skips if already configured).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

ENGINE_URL="${ENGINE_URL:-http://localhost:3005}"
ENGINE_SECRET="${ENGINE_SECRET:-}"
if [[ -z "$ENGINE_SECRET" ]]; then
  # Try to read from .env.engine
  if [[ -f "${PROJECT_ROOT}/src/docker/.env.engine" ]]; then
    ENGINE_SECRET=$(grep -oP '(?<=THIRDWEB_API_SECRET_KEY=).*' "${PROJECT_ROOT}/src/docker/.env.engine" || echo "")
  fi
  if [[ -z "$ENGINE_SECRET" ]]; then
    die "ENGINE_SECRET not set and could not read THIRDWEB_API_SECRET_KEY from .env.engine"
  fi
fi
FUNDED_PK="0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659"
FUNDED_ADDR="0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E"
ENV_BACKEND="${PROJECT_ROOT}/src/docker/.env.backend"

log()  { echo "==> $*"; }
die()  { echo "ERROR: $*" >&2; exit 1; }

engine_call() {
  local method="$1" endpoint="$2"
  shift 2
  curl -sf -X "$method" \
    -H "Authorization: Bearer ${ENGINE_SECRET}" \
    -H "Content-Type: application/json" \
    "$@" \
    "${ENGINE_URL}${endpoint}"
}

log "Waiting for Engine at ${ENGINE_URL}..."
retries=60
until curl -sf "${ENGINE_URL}/system/health" >/dev/null 2>&1; do
  retries=$((retries - 1))
  if [[ $retries -le 0 ]]; then
    die "Engine did not become healthy within 60s"
  fi
  sleep 1
done
log "Engine is healthy."

# 1. Register Arbitrum Local chain override (so Engine routes to local RPC, not thirdweb proxy)
ARB_LOCAL_RPC="${ARB_LOCAL_RPC:-http://host.docker.internal:8547}"
log "Registering chain 412346 → ${ARB_LOCAL_RPC}..."
engine_call POST "/configuration/chains" \
  -d "{
    \"chainOverrides\": [{
      \"name\": \"Arbitrum Local\",
      \"chain\": \"ETH\",
      \"rpc\": [\"${ARB_LOCAL_RPC}\"],
      \"nativeCurrency\": {\"name\": \"Ether\", \"symbol\": \"ETH\", \"decimals\": 18},
      \"chainId\": 412346,
      \"testnet\": true,
      \"slug\": \"arbitrum-local\"
    }]
  }" | jq -r '.result[0].name' 2>/dev/null && log "Chain registered." || die "Failed to register chain"

# 2. Check if wallet exists, import if not
log "Checking wallet..."
wallet_exists=$(engine_call GET "/backend-wallet/get-all" | jq -r ".result[] | select(.address == \"$(echo $FUNDED_ADDR | tr '[:upper:]' '[:lower:]')\") | .address" 2>/dev/null || echo "")
if [[ -z "$wallet_exists" ]]; then
  log "Importing funded wallet ${FUNDED_ADDR}..."
  engine_call POST "/backend-wallet/import" \
    -d "{\"privateKey\":\"${FUNDED_PK}\",\"label\":\"DevnodeFunded\"}" \
    | jq -r '.result.status'
else
  log "Wallet already imported."
fi

# 3. Check if we have a valid access token, create if not
need_new_token=false
log "Checking access tokens..."
current_token=$(grep -oP '(?<=ENGINE_AUTH_TOKEN=).*' "$ENV_BACKEND" 2>/dev/null || echo "")
if [[ -n "$current_token" ]]; then
  token_valid=$(curl -sf -H "Authorization: Bearer ${current_token}" "${ENGINE_URL}/backend-wallet/get-all" 2>/dev/null | jq -r '.result | length' 2>/dev/null || echo "")
  if [[ -n "$token_valid" ]]; then
    log "Current token in .env.backend is valid."
  else
    need_new_token=true
    log "Current token is invalid."
  fi
else
  need_new_token=true
  log "No token found in .env.backend."
fi

if [[ "$need_new_token" == "true" ]]; then
  log "Creating new access token..."
  token_response=$(engine_call POST "/auth/access-tokens/create" \
    -d '{"label":"devnode-automation"}')
  new_token=$(echo "$token_response" | jq -r '.result.accessToken')
  if [[ -z "$new_token" || "$new_token" == "null" ]]; then
    die "Failed to create access token. Response: $token_response"
  fi
  log "Access token created."

  # 4. Update .env.backend with new token
  log "Updating ${ENV_BACKEND}..."
  if grep -q "^ENGINE_AUTH_TOKEN=" "$ENV_BACKEND" 2>/dev/null; then
    tmp_file=$(mktemp)
    awk -v token="$new_token" '/^ENGINE_AUTH_TOKEN=/{print "ENGINE_AUTH_TOKEN=" token; next} {print}' "$ENV_BACKEND" > "$tmp_file"
    mv "$tmp_file" "$ENV_BACKEND"
  else
    echo "ENGINE_AUTH_TOKEN=${new_token}" >> "$ENV_BACKEND"
  fi

  updated_token=$(grep -oP '(?<=ENGINE_AUTH_TOKEN=).*' "$ENV_BACKEND")
  if [[ "$updated_token" == "$new_token" ]]; then
    log ".env.backend updated successfully."
  else
    die "Failed to update .env.backend"
  fi

  NEEDS_BACKEND_RESTART=true
fi

echo ""
echo "Engine setup complete."
echo "  Chain: Arbitrum Local (412346) → ${ARB_LOCAL_RPC}"
echo "  Wallet: ${FUNDED_ADDR}"
if [[ "${NEEDS_BACKEND_RESTART:-}" == "true" ]]; then
  echo ""
  echo "  New token written. Recreate backend container:"
  echo "    docker compose -f src/docker/docker-compose.yaml up -d --force-recreate scm-backend"
else
  echo "  Token: valid (no changes needed)"
fi
