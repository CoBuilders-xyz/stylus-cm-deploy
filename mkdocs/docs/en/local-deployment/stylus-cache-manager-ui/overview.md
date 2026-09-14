# **🏗️ Stylus Manager UI: Local Deployment Overview**

> **Deploy and run the complete Stylus Manager UI system locally** for development, testing, or self-hosted production use. This guide covers everything from repository setup to full system deployment.

---

## **🎯 What You'll Build**

This deployment guide will help you set up the complete Stylus Manager ecosystem locally:

- **📦 Smart Contracts:** Stylus Manager automation contracts for independent cache bidding and reactivation
- **🤖 ThirdWeb Engine:** Self-hosted automation service for executing transactions
- **🔧 Backend API:** RESTful service for managing contracts, activation state, bids, alerts, and automations
- **🖥️ Frontend UI:** Modern web interface for activation and cache management

---

## **🔧 Prerequisites**

Before starting, ensure you have:

- **Node.js** (v22 or higher) and **npm**
- **Docker** and **Docker Compose** for containerized services
- **Git** for repository management
- **Arbitrum Testnode** (optional, for local blockchain testing)
- **ThirdWeb Account** for Engine service configuration

---

## **📋 Deployment Steps**

### **1. [Clone the Repository](clone-the-repo.md)**

Set up the project with all submodules and dependencies.

### **2. [Deploy Automation Contracts](deploy-cma-contracts.md)**

Deploy the Stylus Manager automation contracts to your chosen network. Their Solidity identifiers remain `CacheManagerAutomation` and `BiddingEscrow`.

### **3. [Configure ThirdWeb Engine](third-web-engine.md)**

Set up the self-hosted automation service for executing automated bids and activations.

### **4. [Stylus Manager Backend](scm-ui-backend.md)**

Configure and deploy the backend API service.

### **5. [Stylus Manager Frontend](scm-ui-frontend.md)**

Connect the web app to the configured backend. For an existing installation, read the [v2 upgrade notes](../../releases/stylus-manager-v2.md#upgrading-to-stylus-manager-v2) before changing CMA addresses or migrating the database.

## **🚀 Quick Start**

Ready to get started? Begin with **[Cloning the Repository](clone-the-repo.md)** to set up your development environment.
