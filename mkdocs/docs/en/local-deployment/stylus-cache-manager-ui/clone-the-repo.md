# **📦 Clone the Repository**

> **Set up your development environment** by cloning the Stylus Cache Manager repository with all its submodules and dependencies.

---

## **🔗 Repository Structure**

The Stylus Cache Manager project consists of several interconnected components:

- **📦 Main Repository:** Deployment scripts and configuration
- **🔧 Smart Contracts:** Cache Manager Automation contracts
- **🤖 Backend API:** RESTful service for cache management
- **🖥️ Frontend UI:** Next.js web application

---

## **🚀 Quick Clone (Recommended)**

Clone the repository with all submodules in one command:

```bash
git clone --recurse-submodules https://github.com/cobuilders-xyz/stylus-cm-deploy
cd stylus-cm-deploy
```

!!! success "All-in-One Setup"

    This command automatically downloads all submodules and their dependencies, giving you a complete development environment.

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
npm install

# Frontend dependencies
cd ../stylus-cm-frontend
npm install

# Smart contracts dependencies
cd ../stylus-cm-contracts
npm install

# Return to root directory
cd ../../
```

!!! tip "Dependency Management"

    The automated script ensures all submodules are properly initialized with their required dependencies. Use this approach for consistent setup across different environments.

---

## **🔧 Next Steps**

With your repository cloned and dependencies installed, you're ready to:

1. **[Deploy CMA Contracts](deploy-cma-contracts.md)** - Deploy smart contracts to your chosen network
2. **[Configure ThirdWeb Engine](third-web-engine.md)** - Set up automation services
3. **[SCM UI Backend](scm-ui-backend.md)** - Configure the backend API
