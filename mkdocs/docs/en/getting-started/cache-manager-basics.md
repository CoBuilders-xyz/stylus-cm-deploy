# **🔗 Activation & Caching Basics**

> **Start with the lifecycle.** Stylus Manager helps keep a program executable and manage its cache slot. These are separate operations with separate status indicators.

---

## **📖 Names used in these guides**

| Name | Meaning |
| --- | --- |
| **Stylus Manager** | The application for activation, caching, automation, and alerts. |
| **Auto-activation** | The application's automatic reactivation feature. |
| **Cache bid automation** | The application's automated cache-bidding feature. |
| **Stylus Manager automation contracts** | The contracts supporting both features: `CacheManagerAutomation` (CMA) and `BiddingEscrow`. |
| **CacheManager** | Arbitrum's on-chain cache auction contract. |
| **ArbWasm / ArbWasmCache** | Arbitrum precompiles for activation and cache operations. |

`CacheManagerAutomation` remains the deployed Solidity contract name in v2. Source paths, ABI fields, environment variables, and repository names retain their technical identifiers.

## **📋 Deploy, activate, then cache**

1. **Deploy:** publish the program's compressed WASM bytecode at an address.
2. **Activate:** register that program with **ArbWasm** so it can execute on the current Stylus version.
3. **Cache, optionally:** bid through **CacheManager** for space that reduces the gas cost of repeated calls.

Activation and cache membership are associated with the program's **codehash**. Two addresses with identical program code can share these states. A new build with a different codehash needs its own checks.

## **⚡ Activation**

The **Activation** tab shows whether a program is active, expiring, inactive, in error, or still unknown. A program may need activation because it has never been activated, its lifetime expired, or the chain requires a newer Stylus version.

Use **Activate now** for a manual transaction. After first activation, you can configure **Auto-activation** to reactivate an expired or upgrade-required program. Automation reacts after activation becomes necessary; it does not extend the lifetime in advance.

See [Activate a Contract](stylus-cache-manager-ui/tutorials/activation.md) or the [activation lifecycle deep dive](../deep-dive/activation-lifecycle.md).

## **💰 Caching**

The **Cache** tab shows cache membership, bid history, and eviction risk. Cache capacity is limited: bids compete for space and their auction value decays with time. An accepted bid can later be evicted. Retention depends on auction demand and the chain's cache parameters.

Read the current minimum for the program before bidding. It can be **0 ETH** when there is enough space, but a zero-value bid still requires a transaction and transaction gas. Manual bidding is disabled while the program is already cached.

See [Place a Bid](stylus-cache-manager-ui/tutorials/place-bid.md) and [Cache Bid Automation](stylus-cache-manager-ui/tutorials/bid-automation.md).

## **⛽ How payments work**

| Action | Funds used |
| --- | --- |
| Manual activation | Connected wallet: activation value and transaction gas. |
| Manual cache bid | Connected wallet: bid value and transaction gas. |
| Automatic activation or cache bid | Your **Gas Tank** balance on the selected chain and CMA deployment pays the operation value; the operator submits the transaction. |
| Save automation, deposit, or withdraw | Connected wallet pays transaction gas. |

The Gas Tank is shared by your automated activations and cache bids within the same CMA deployment. Enabling one feature does not enable the other. Funds and settings on an older CMA deployment do not automatically move to v2.

## **🌐 Find the right network and contracts**

Select a network in the app and use a wallet on that same network for writes. The available networks come from the backend's enabled blockchain configuration.

| Network | Chain ID | Public RPC |
| --- | --- | --- |
| Arbitrum One | `42161` | `https://arb1.arbitrum.io/rpc` |
| Arbitrum Sepolia | `421614` | `https://sepolia-rollup.arbitrum.io/rpc` |
| Repository local devnode | `412346` | `http://localhost:8547` |

On these Stylus-enabled chains, **ArbWasm** is at `0x0000000000000000000000000000000000000071`, and **ArbWasmCache** is at `0x0000000000000000000000000000000000000072`. CacheManager and CMA have different, network-specific addresses.

Discover the chain's CacheManager with:

```bash
cargo stylus cache status --endpoint=<RPC_ENDPOINT>
```

For CMA v2 deployment records, see [Deploy Automation Contracts](../local-deployment/stylus-cache-manager-ui/deploy-cma-contracts.md). The frontend receives its CMA address from the backend's `/blockchains` endpoint.

## **📚 Protocol references**

- [Arbitrum: activation](https://docs.arbitrum.io/stylus/concepts/activation)
- [Arbitrum: caching contracts](https://docs.arbitrum.io/stylus/how-tos/caching-contracts)
