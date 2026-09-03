# Direct Cache and Activation Calls with Hardhat 3

This small ESM project demonstrates the two direct contract interactions used in the companion caching and activation guides. It uses Hardhat 3 with the ethers v6 plugin and is intentionally independent from the Stylus Manager application.

The [activation tutorial](https://cobuilders-xyz.github.io/stylus-cm-deploy/tutorials/activation/#appendix-prerequisites-and-demo-setup) and [caching tutorial](https://cobuilders-xyz.github.io/stylus-cm-deploy/tutorials/caching/#appendix-prerequisites-and-demo-setup) each contain a complete, independent environment, wallet, and demo-program setup.

## Prerequisites

- Node.js 22.13 or newer, as required by Hardhat 3.
- A disposable wallet funded with Arbitrum Sepolia ETH.
- A deployed Stylus program. Caching requires an active, uncached program; activation requires an inactive, expired, or upgrade-required program.

Never use a production key for a tutorial. The `.env` file is ignored by Git, but terminal output and screen recordings can still leak secrets.

## Setup

```bash
npm ci
test -f .env || cp .env.example .env
```

Edit `.env` with your RPC URL, test-wallet key, and program address. Then check the TypeScript project:

```bash
npm run check
```

Hardhat 3 creates network connections explicitly. Each script calls `network.create()`, while `--network arbitrumSepolia` selects the HTTP network declared in `hardhat.config.ts`. The npm scripts include `--no-compile` because these examples call existing precompiles and do not contain Solidity sources.

## Cache a program

```bash
npm run cache -- --network arbitrumSepolia
```

The script:

1. Computes the deployed program's codehash.
2. Checks its current cache status through the ArbWasmCache precompile.
3. Discovers the active CacheManager rather than hardcoding its address.
4. Reads the current minimum bid and calls `placeBid` with that amount, unless `CACHE_BID_WEI` overrides it.
5. Waits for confirmation and verifies the codehash is cached.

The minimum bid can change as the cache auction changes. If an explicitly configured bid becomes too low, read the new minimum and retry.

## Activate a program

```bash
npm run activate -- --network arbitrumSepolia
```

The script calls the ArbWasm precompile at `0x0000000000000000000000000000000000000071`. It first simulates `activateProgram` with `ACTIVATION_FEE_CEILING_ETH`, obtains the quoted data fee, submits the real transaction with that value, and finally checks `programTimeLeft`.

If the simulation reports insufficient value, raise the ceiling rather than guessing the final fee. An already active and up-to-date program exits without sending a transaction.

## Environment variables

| Variable | Required | Purpose |
| --- | --- | --- |
| `ARB_SEPOLIA_RPC_URL` | No | Defaults to Arbitrum's public Sepolia RPC. |
| `PRIVATE_KEY` | Yes for writes | Disposable, funded Sepolia signer. |
| `STYLUS_CONTRACT_ADDRESS` | Yes | Target Stylus program. |
| `CACHE_BID_WEI` | No | Explicit bid in wei; otherwise use `getMinBid`. |
| `ACTIVATION_FEE_CEILING_ETH` | No | Simulation ceiling; defaults to `0.01`. |

## Common failures

- **Wrong chain:** include `--network arbitrumSepolia`.
- **No signer:** add a valid `PRIVATE_KEY` to `.env`.
- **No bytecode:** check the address and selected chain.
- **Already cached:** use a fresh codehash for the caching demo.
- **Bid too small:** remove the override or update it from the latest minimum.
- **Activation simulation failed:** verify that the address is a Stylus program and increase the fee ceiling if necessary.
