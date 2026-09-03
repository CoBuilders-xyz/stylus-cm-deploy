# Tutorial examples

This directory contains the runnable files used by the documentation tutorials:

- [Contract activation](https://cobuilders-xyz.github.io/stylus-cm-deploy/tutorials/activation/)
- [Contract caching](https://cobuilders-xyz.github.io/stylus-cm-deploy/tutorials/caching/)
- [Direct CacheManager and ArbWasm calls with Hardhat](hardhat/README.md)

The tutorials generate disposable Stylus projects under `examples/generated-programs`. That directory, the shared `.env`, and the generated Cargo key file are intentionally ignored by Git.

Start from the repository root:

```bash
export STYLUS_REPO_ROOT="$(git rev-parse --show-toplevel)"
export STYLUS_EXAMPLES_ROOT="$STYLUS_REPO_ROOT/examples"

test -f "$STYLUS_EXAMPLES_ROOT/.env" ||
  cp "$STYLUS_EXAMPLES_ROOT/.env.example" "$STYLUS_EXAMPLES_ROOT/.env"
```

Use only a disposable wallet funded with Arbitrum Sepolia ETH. After filling in `examples/.env`, source `examples/setup-wallet.sh` as described in either tutorial.
