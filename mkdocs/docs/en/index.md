---
hide:
  - toc
---

# **Welcome to Stylus Manager 🚀**

**Stylus Manager** helps developers and operators manage both **activation** and **caching** for Stylus contracts on Arbitrum. It brings wallet actions, lifecycle monitoring, automation, and alerts into one web app.

Previously called **Stylus Cache Manager**, the project now covers the program lifecycle as well as the cache auction. The underlying contracts keep their names: **ArbWasm** handles activation, **CacheManager** handles caching, and **CacheManagerAutomation (CMA)** coordinates automated operations.

---

## **🔹 Two jobs, one workspace**

| Job | What it does | What you can do in Stylus Manager |
| --- | --- | --- |
| **Activation** | Makes deployed WASM executable for the chain's current Stylus version. | Activate manually, inspect remaining lifetime, configure automatic reactivation, and receive expiration alerts. |
| **Caching** | Reserves space in the WASM cache to reduce repeated-call gas costs. | Place bids, inspect cache status and bid history, configure automatic bidding, and receive eviction alerts. |

An active contract can run without a cache slot. A cache slot does not replace a valid activation. Start with the [activation and caching basics](getting-started/cache-manager-basics.md) to understand both states.

---

## **🚀 Choose your next step**

- **Use the app:** follow the [UI overview](getting-started/stylus-cache-manager-ui/overview.md) and its screenshot-guided tutorials.
- **Try the full workflows:** [activate a contract](tutorials/activation.md) or [cache a contract](tutorials/caching.md) using Cargo, Hardhat, or Stylus Manager.
- **Upgrade an installation:** review [what changed in v2](releases/stylus-manager-v2.md), including CMA compatibility and database migrations.
- **Integrate or self-host:** explore the [API reference](api-reference.md) and [deployment guide](local-deployment/stylus-cache-manager-ui/overview.md).

## **🏗️ Project at a glance**

| Submodule | Purpose |
| --- | --- |
| `stylus-cm-contracts` | CMA and escrow contracts, deployment records, tests, and audit report. |
| `stylus-cm-backend` | REST API, blockchain indexing, activation and bidding workers, and notifications. |
| `stylus-cm-frontend` | Next.js app for activation, caching, funding, and monitoring. |
| `stylus-cm-nginx` | Reverse proxy configuration. |
| `nitro-testnode` | Local Arbitrum node for testing. |

Repository names and existing documentation URLs retain `stylus-cm` for continuity.

## **🔗 Quick links**

- Public app: **<https://stylus.cobuilders.xyz>**
- Source: **<https://github.com/cobuilders-xyz/stylus-cm-deploy>**
- Documentation: **<https://cobuilders-xyz.github.io/stylus-cm-deploy/>**
