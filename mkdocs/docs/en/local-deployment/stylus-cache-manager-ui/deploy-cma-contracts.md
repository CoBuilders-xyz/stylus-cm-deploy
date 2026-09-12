# **📦 Deploy Automation Contracts**

> **CacheManagerAutomation v2.0.0** coordinates automated cache bidding and reactivation. Its constructor creates a **BiddingEscrow** for user funds and receives the addresses of CacheManager, ArbWasmCache, and ArbWasm.

## **Published v2 deployments**

These are the deployment records shipped with the September 2026 release. They are CMA addresses, not CacheManager addresses.

| Network | CacheManagerAutomation v2.0.0 | BiddingEscrow |
| --- | --- | --- |
| Arbitrum One | `0x42affF7D0e6649fc006B5Dd9131373f869e622AF` | `0xC70eA08fDC7c036681E2982cF96B5B4640dbBEF7` |
| Arbitrum Sepolia | `0x4f64b21496B319dCaef26EDd165cab3039f5aD86` | `0x888718dB940bC666DBBa44F59bE77f1e174D605c` |

Sources: [One deployment PR](https://github.com/CoBuilders-xyz/stylus-cm-contracts/pull/24), [Sepolia deployment PR](https://github.com/CoBuilders-xyz/stylus-cm-contracts/pull/23), and the versioned files under `submodules/stylus-cm-contracts/ignition/deployments/`.

A self-hosted automation worker should use a deployment it operates. Do not start an additional worker against a public CMA already served by another operator.

## **⚙️ Prepare a deployment**

From the repository root:

```bash
cd submodules/stylus-cm-contracts
npm ci
test -f .env || cp .env.example .env
```

Configure the target network's RPC and funded deployer using `.env.example` and `config/networks.ts`. For example, the local signer uses `ARB_LOCAL_FUNDED_PK`, while Sepolia uses `ARB_SEPOLIA_FUNDED_PK`. Keep private keys in your local environment file.

Review `config/constants.ts` and `config/deployment-config.ts`. The target chain must provide the Stylus precompiles and a working CacheManager. Confirm all three addresses before deployment.

## **🚀 Run Hardhat Ignition**

Choose one target:

```bash
# Disposable local Nitro devnode
npm run deploy:local

# Arbitrum Sepolia
npm run deploy:sepolia

# Arbitrum One
npm run deploy:arbitrum
```

These scripts run `scripts/deploy/deploy-cache-manager-automation-ignition.ts`. The direct equivalent for a local deployment is:

```bash
npx hardhat run scripts/deploy/deploy-cache-manager-automation-ignition.ts --network localArb
```

The script derives the Ignition module version from `package.json` (`2.0.0` → `CacheManagerAutomation_2_0_0`). Ignition records deployments by chain under `ignition/deployments/chain-<chainId>/deployed_addresses.json` and may reuse a recorded deployment. Inspect the records before assuming a command will create a new contract.

### **Local CacheManager setup**

If your disposable Nitro devnode needs a CacheManager, the repository provides:

```bash
npx hardhat run scripts/deploy/deploy-cache-manager-devnode.ts --network localArb
```

This script is restricted to `localArb` and requires the devnode chain-owner authority for registration. It uses the tracked `abis/external/cacheManager.abi.json` artifact by default. It is not a public-network deployment command.

## **✅ Verify and configure the stack**

1. Record the CMA address and read its `escrow()`, `cacheManager()`, `arbWasmCache()`, `arbWasm()`, and `owner()` values.
2. Inspect funding, bid, user-count, and batch limits on-chain. Values in configuration files or constructor defaults do not establish the current deployed settings.
3. Set `ARB_LOCAL_CMA_ADDRESS`, `ARB_SEPOLIA_CMA_ADDRESS`, or `ARB_ONE_CMA_ADDRESS` in the backend environment.
4. Use the v2 frontend and backend ABIs together. The frontend receives the CMA address from `/blockchains`; there is no separate frontend CMA-address variable.
5. Configure the Engine worker and independently enable caching and activation automation as needed.

For a custom Orbit chain, add its network to `config/networks.ts`, all three contract addresses to `config/constants.ts`, and an entry in `config/deployment-config.ts` including `arbWasmAddress`. Confirm that the chain supports the required Stylus behavior.

See [v2 compatibility and audit notes](../../releases/stylus-manager-v2.md), then continue with [ThirdWeb Engine](third-web-engine.md) and [Backend Deployment](scm-ui-backend.md).
