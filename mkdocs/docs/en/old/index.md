---
hide:
  - toc
---

!!! info "Archived documentation"

    This page is retained as historical reference. For the current Stylus Manager release, use the [activation, caching, and deployment guides](../index.md). Commands and architecture in archived notes may describe earlier versions.

# **Stylus Manager Documentation Archive**

These pages preserve earlier experiments and setup notes for **Stylus Manager**. For activation, caching, automation, and alerts in the current release, start with the [current documentation](../index.md).

---

## 🔹 **Stylus Manager today**

**Stylus Manager** manages activation and caching as separate workflows. Its backend workers submit automated cache bids and reactivation transactions through ThirdWeb Engine. `CacheManagerAutomation` and `BiddingEscrow` provide the shared on-chain automation and funding layer.

Earlier notes in this archive include Chainlink experiments. Those experiments do not describe the current worker architecture.

---

## 📌 **Getting Started**

For historical reference, the earlier guides are retained here:

📖 [**CacheManager Reference**](getting-started/01-cmUsefulInfo.md) – Understand the core mechanics of CacheManager.
⚙️ [**Nitro Test Node**](getting-started/02-nitroTestNodeRunAndAddresses.md) – Set up and interact with a local Nitro test node.
🔗 [**CacheManager Interactions**](getting-started/03-cacheManagerInteractions.md) – Learn how to manually interact with CacheManager.
🛠️ [**Guided Testing**](getting-started/04-CmGuidedTesting.md) – Step-by-step testing workflow.

---

## 🏗️ **Project Components**

### 🔷 **Stylus Manager Automation Contracts**

- **[Overview](stylus-cm-contracts/overview.md)** – Dive into the contract architecture.
- **[Local Testing](stylus-cm-contracts/testing.md)** – Set up and test contracts locally with Foundry & Hardhat.

### 🔷 **System Deployment (WIP)**

- **[Local Deployment](local-deployment/index.md)** – Deploy and test the system in a local environment.
- **[Docker Deployment](local-deployment/docker-compose/deployment/system-deployment.md)** – Spin up the system using **Docker Compose**.
- **[Kubernetes Deployment](local-deployment/kubernetes/deployment/system-deployment.md)** – Run the system on a **K8s cluster** for scalability.
