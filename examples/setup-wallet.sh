setup_stylus_wallet() {
  local repo_root examples_env hardhat_env private_key derived_address

  repo_root="$(git rev-parse --show-toplevel)" || return 1
  export STYLUS_EXAMPLES_ROOT="$repo_root/examples"
  examples_env="$STYLUS_EXAMPLES_ROOT/.env"
  hardhat_env="$STYLUS_EXAMPLES_ROOT/hardhat/.env"

  if [ ! -f "$examples_env" ]; then
    printf 'Missing %s. Copy .env.example to .env and add your funded disposable wallet.\n' \
      "$examples_env" >&2
    return 1
  fi

  export STYLUS_WALLET_ADDRESS="$(
    sed -n 's/^STYLUS_WALLET_ADDRESS=//p' "$examples_env" | tail -n 1 | tr -d '\r'
  )"
  private_key="$(
    sed -n 's/^PRIVATE_KEY=//p' "$examples_env" | tail -n 1 | tr -d '\r'
  )"

  printf '%s\n' "$STYLUS_WALLET_ADDRESS" |
    grep -Eq '^0x[[:xdigit:]]{40}$' || {
      printf 'STYLUS_WALLET_ADDRESS must be a valid address in %s.\n' "$examples_env" >&2
      return 1
    }
  printf '%s\n' "$private_key" |
    grep -Eq '^0x[[:xdigit:]]{64}$' || {
      printf 'PRIVATE_KEY must be a 32-byte hex key in %s.\n' "$examples_env" >&2
      return 1
    }

  derived_address="$(cast wallet address --private-key "$private_key")" || return 1
  if [ "$(printf '%s' "$derived_address" | tr '[:upper:]' '[:lower:]')" != \
       "$(printf '%s' "$STYLUS_WALLET_ADDRESS" | tr '[:upper:]' '[:lower:]')" ]; then
    printf 'PRIVATE_KEY does not belong to STYLUS_WALLET_ADDRESS.\n' >&2
    return 1
  fi

  export KEY_PATH="$STYLUS_EXAMPLES_ROOT/disposable-private-key.txt"
  printf '%s\n' "$private_key" > "$KEY_PATH" || return 1

  test -f "$hardhat_env" ||
    cp "$STYLUS_EXAMPLES_ROOT/hardhat/.env.example" "$hardhat_env" ||
    return 1
  sed -i "s/^PRIVATE_KEY=.*/PRIVATE_KEY=$private_key/" "$hardhat_env" || return 1

  printf 'Wallet address: %s\nCargo key file: %s\nHardhat env: %s\n' \
    "$STYLUS_WALLET_ADDRESS" "$KEY_PATH" "$hardhat_env"
  printf 'Sepolia balance: '
  cast balance "$STYLUS_WALLET_ADDRESS" \
    --rpc-url "$ARB_SEPOLIA_RPC" \
    --ether
}

setup_stylus_wallet
