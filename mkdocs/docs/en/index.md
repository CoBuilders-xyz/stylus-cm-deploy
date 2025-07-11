---
hide:
  - toc
---

# **Welcome to the Stylus Cache Manager 🚀**

This documentation is the **central knowledge base** for anyone working with the **Stylus Cache Manager (CM)** – from smart-contract developers and dev-ops engineers to testers and end-users running their own deployments.

Stylus CM sits on top of Arbitrum’s **CacheManager** contract and provides everything you need to **reserve, monitor, and automatically maintain cache slots** for high-performance Stylus applications.

---

## 🔹 What is the Cache Manager?

On Arbitrum, stylus contracts can bid for dedicated space in a low-latency **WASM cache**. Holding a slot dramatically **reduces gas costs** and speeds up hot-path calls, but it requires managing periodic bids to keep the slot alive.

Stylus Cache Manager simplifies this process by providing:

- **Smart-contracts** that encapsulate bidding logic and escrow-based fund management.
- **Chainlink Automation jobs** that keep your bids active 24/7.
- **A full-featured web UI** with live dashboards, alerting, and one-click actions.
- **Docker-first deployment scripts** so you can run the entire stack locally or on-prem.

---

## 🏗️ Project at a glance

This repository is a **meta-project** that pulls together several sub-modules:

| Sub-module            | Description                                                |
| --------------------- | ---------------------------------------------------------- |
| `stylus-cm-contracts` | Solidity / Stylus contracts + Foundry tests                |
| `stylus-cm-backend`   | REST & WebSocket API powering the UI and automation agents |
| `stylus-cm-frontend`  | Next.js dApp for interacting with Cache Manager            |
| `stylus-cm-nginx`     | Reverse-proxy with TLS & static assets                     |
| `nitro-testnode`      | Arbitrum Nitro local node + Blockscout explorer            |

---

## 🚀 Quick links

- Public dApp: **<https://stylus.cobuilders.xyz>**
- Source code: **<https://github.com/cobuilders-xyz/stylus-cm-deploy>**
- Live docs (this site): **<https://cobuilders-xyz.github.io/stylus-cm-deploy/>**

---

## 📌 Next steps

Ready to dive in?

1. Head over to **[Getting Started ➜ Cache Manager Info](getting-started/cache-manager-info.md)** for a conceptual overview.
2. Spin up a **local Arbitrum test node** and interact with CM by following **Guided Testing**.
3. When you’re comfortable, deploy the **full system with Docker Compose** or explore other deployment options.

Use the navigation panel on the left (or top-bar on mobile) to explore every part of Stylus Cache Manager.

> 💡 **Tip:** Documentation is a work in progress. If you spot an issue or want to contribute, open a PR or file an issue on GitHub!
