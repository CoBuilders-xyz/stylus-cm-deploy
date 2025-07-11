---
hide:
  - toc
---

### **Welcome to the Stylus Cache Manager 🚀**

This documentation serves as the **go-to resource** for developers, testers, and users interacting with the **Stylus Cache Manager**. Whether you’re integrating smart contracts, setting up automation, or deploying the system, you’ll find everything you need here.

---

## 🔹 **What is the Cache Manager?**

The **Stylus Cache Manager** optimizes contract execution by allowing contracts to reserve and maintain storage in the cache layer. This system enables faster access and **reduces gas costs** for frequently used contracts. However, contracts must actively **bid for cache space**—this is where our **automation** and **bidding logic** come into play.

Our solution provides:  
✅ **Smart contract interactions** for managing bids and cache slots.  
✅ **Automated bidding** using Chainlink Automation.  
✅ **A user-friendly dApp** to simplify contract management.

---

## 📌 **Getting Started**

If you’re new to the system, follow these guides:

📖 [**Cache Manager Info**](getting-started/01-cmUsefulInfo.md) – Understand the core mechanics of CacheManager.  
⚙️ [**Nitro Test Node**](getting-started/02-nitroTestNodeRunAndAddresses.md) – Set up and interact with a local Nitro test node.  
🔗 [**CM Interactions**](getting-started/03-cacheManagerInteractions.md) – Learn how to manually interact with CacheManager.  
🛠️ [**Guided Testing**](getting-started/04-CmGuidedTesting.md) – Step-by-step testing workflow.

---

## 🏗️ **Project Components**

### 🔷 **Stylus CM Contracts**

- **[Overview](stylus-cm-contracts/overview.md)** – Dive into the contract architecture.
- **[Local Testing](stylus-cm-contracts/testing.md)** – Set up and test contracts locally with Foundry & Hardhat.

### 🔷 **System Deployment (WIP)**

- **[Local Deployment](local-deployment/index.md)** – Deploy and test the system in a local environment.
- **[Docker Deployment](local-deployment/docker-compose/deployment/system-deployment.md)** – Spin up the system using **Docker Compose**.
- **[Kubernetes Deployment](local-deployment/kubernetes/deployment/system-deployment.md)** – Run the system on a **K8s cluster** for scalability.
