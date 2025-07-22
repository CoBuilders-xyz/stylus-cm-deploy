# **🖥️ SCM UI Frontend Deployment**

> **Deploy the Stylus Cache Manager frontend** - the modern web interface that provides an intuitive way to manage your Stylus contracts, place bids, and configure automated bidding.

---

## **🎯 What is the SCM UI Frontend?**

The **SCM UI Frontend** is a Next.js web application that provides:

- **🔐 Wallet Authentication:** Secure login with Ethereum wallets
- **📋 Contract Management:** View and organize your Stylus contracts
- **💰 Manual Bidding:** Place bids directly from the web interface
- **🤖 Automation Setup:** Configure automated bidding strategies
- **📊 Real-time Analytics:** Monitor cache status and bid performance
- **🔔 Alert Management:** Set up and manage notification preferences
- **🌐 Multi-chain Support:** Work with multiple Arbitrum networks

---

## **🔧 Prerequisites**

Before deploying the frontend, ensure you have:

- **✅ SCM UI Backend** running and accessible
- **✅ Node.js** (v22 or higher) and **npm**
- **✅ Modern web browser** with wallet extension (MetaMask, etc.)
- **✅ Funded wallet** for testing transactions
- **🌐 Backend API** accessible at `http://localhost:3000`

---

## **⚙️ Configuration Setup**

### **1. Navigate to Frontend Directory**

```bash
cd submodules/stylus-cm-frontend
```

!!! tip "Directory Structure"

    The frontend is located in the `submodules/stylus-cm-frontend` directory as part of the monorepo structure.

---

## **🔧 Environment Configuration**

### **Create Environment File**

Create a `.env` file in the frontend directory:

```bash
# Create environment file
touch .env
```

### **Configure Environment Variables**

Add the following configuration to `.env`:

```bash
# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:3000

# Default Chain Configuration
NEXT_PUBLIC_DEFAULT_CHAIN_ID=421614
```

!!! tip "Chain Configuration"

    We're using **Arbitrum Sepolia** (chain ID: 421614) as the default network for testing. You can change this to any supported Arbitrum network.

### **Supported Networks**

| **Network**             | **Chain ID** | **Use Case**                    |
| ----------------------- | ------------ | ------------------------------- |
| 🏠 **Arbitrum Local**   | 412346       | Local development and testing   |
| 🔵 **Arbitrum Sepolia** | 421614       | Staging and integration testing |
| 🟢 **Arbitrum One**     | 42161        | Production deployment           |

---

## **🚀 Development Deployment**

### **Install Dependencies**

Ensure all dependencies are installed:

```bash
npm install
```

### **Start Development Server**

Launch the frontend in development mode:

```bash
npm run dev
```

!!! success "Frontend Running"

    Your frontend will be available at: **http://localhost:5000**

---

## **🔍 Verification & Testing**

### **1. Access the Application**

Open your browser and navigate to:

```
http://localhost:5000
```

### **2. Connect Your Wallet**

1. **Click "Connect Wallet"** in the top navigation
2. **Select your wallet provider** (MetaMask, WalletConnect, etc.)
3. **Approve the connection** in your wallet
4. **Verify connection status** shows as connected

### **3. Test Core Features**

Verify the following functionality:

- **✅ Wallet Connection:** Successfully connect your wallet
- **✅ Network Detection:** Correct network is detected
- **✅ API Communication:** Backend API is responding
- **✅ Contract Loading:** Your contracts are displayed
- **✅ Navigation:** All menu items are accessible

---

## **✅ Deployment and System Complete**

Congratulations! Your SCM UI Frontend is now **🖥️ Running on port 5000** at http://localhost:5000

You've successfully deployed the complete Stylus Cache Manager system:

- **📦 Smart Contracts** - CMA contracts deployed
- **🤖 ThirdWeb Engine** - Automation service configured
- **🔧 Backend API** - Data processing and management
- **🖥️ Frontend UI** - User interface and interactions
