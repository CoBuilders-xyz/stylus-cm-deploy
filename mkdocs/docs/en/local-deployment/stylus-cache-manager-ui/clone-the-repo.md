# **📦 Clone the Repository**

> **Set up your development environment** by cloning the Stylus Manager repository with all its submodules and dependencies.

---

## **🔗 Repository Structure**

The Stylus Manager project consists of several interconnected components:

- **📦 Main Repository:** Deployment scripts and configuration
- **🔧 Smart Contracts:** Stylus Manager automation contracts (`CacheManagerAutomation` and `BiddingEscrow`)
- **🤖 Backend API:** REST API for activation, caching, and alerts
- **🖥️ Frontend UI:** Next.js web application

---

## **🚀 Quick Clone (Recommended)**

Clone the repository with all submodules in one command:

```bash
git clone --recurse-submodules https://github.com/cobuilders-xyz/stylus-cm-deploy
cd stylus-cm-deploy
```

!!! success "All-in-One Setup"

    This command downloads the recorded submodule commits. Install their package dependencies separately below.

---

## **🔄 Alternative: Clone Without Submodules**

If you've already cloned without submodules, you can initialize them afterward:

```bash
# If you already cloned without --recurse-submodules
git clone https://github.com/cobuilders-xyz/stylus-cm-deploy
cd stylus-cm-deploy

# Initialize and pull submodules
git submodule update --init --recursive
```

---

## **🔄 Follow the Merged Release**

The repository records exact submodule commits for reproducible checkouts. To deliberately update to the latest merged release, start with clean submodules and run:

```bash
git pull --ff-only origin main
for module in stylus-cm-contracts stylus-cm-backend stylus-cm-frontend stylus-cm-nginx; do
  git -C "submodules/$module" switch main || break
  git -C "submodules/$module" pull --ff-only origin main || break
done
git -C submodules/nitro-testnode switch release
git -C submodules/nitro-testnode pull --ff-only origin release
```

Nitro uses this fork's `release` branch; the four Stylus Manager submodules use `main`. Record updated submodule pointers in the parent repository when preparing a release.

## **📦 Install Dependencies**

### **Option 1: Automated Setup (Recommended)**

Use the provided npm script to install all dependencies:

```bash
npm run submodules:init
```

### **Option 2: Manual Installation**

If you prefer manual control, install dependencies for each submodule:

```bash
# Backend dependencies
cd submodules/stylus-cm-backend
npm ci

# Frontend dependencies
cd ../stylus-cm-frontend
npm ci

# Smart contracts dependencies
cd ../stylus-cm-contracts
npm ci

# Return to root directory
cd ../../
```

!!! tip "Dependency Management"

    The automated script ensures all submodules are properly initialized with their required dependencies.

---

## **⚙️ Initialize Environment Files**

Create your environment configuration files from the provided templates:

```bash
npm run envs:init
```

This command copies all `.example` environment files to their active versions:

- `.env.backend.example` → `.env.backend`
- `.env.engine.example` → `.env.engine`
- `.env.engine-db.example` → `.env.engine-db`
- `.env.scm-db.example` → `.env.scm-db`

!!! info "Template Creation Only"

    This step only creates the environment files from templates. **You'll configure the actual values** in the corresponding sections.

!!! tip "Safe to Re-run"

    The initialization script only creates missing files and won't overwrite existing environment configurations.

---

## **🔧 Next Steps**

With your repository cloned, dependencies installed, and environment files initialized, you're ready to:

1. **[Deploy Automation Contracts](deploy-cma-contracts.md)** - Deploy smart contracts to your chosen network
2. **[Configure ThirdWeb Engine](third-web-engine.md)** - Set up automation services
3. **[Stylus Manager Backend](scm-ui-backend.md)** - Configure the backend API
