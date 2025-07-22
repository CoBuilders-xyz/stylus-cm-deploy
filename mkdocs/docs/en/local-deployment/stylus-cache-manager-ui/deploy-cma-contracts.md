# **📦 Deploy CMA Contracts**

> **Deploy Cache Manager Automation smart contracts** to enable automated bidding functionality for your Stylus contracts.

---

## **🎯 What Are CMA Contracts?**

The **Cache Manager Automation (CMA)** contracts provide the smart contract foundation for:

- **🤖 Automated Bidding:** Execute bids automatically based on configured rules
- **💰 Bid Management:** Handle bid placement, updates, and withdrawals
- **🔒 Security:** Secure automation logic with proper access controls
- **📊 Monitoring:** Track bid status and automation performance

---

## **🌐 Supported Networks**

The deployment scripts support multiple Arbitrum networks:

| **Network**             | **Environment** | **Use Case**                  |
| ----------------------- | --------------- | ----------------------------- |
| 🏠 **Local Testnode**   | Development     | Local testing and development |
| 🔵 **Arbitrum Sepolia** | Staging         | Integration testing           |
| 🟢 **Arbitrum One**     | Production      | Live production deployment    |

We also suport any kind of Arbitrum Orbit Chain that has their Cache Manager contract deployed.

!!! tip "Network Selection"

    In this guide we will be using **Arbitrum Sepolia** and **Arbitrum Local Testnode**.

---

## **⚙️ Configuration Setup**

### **1. Navigate to Contracts Directory**

```bash
cd submodules/stylus-cm-contracts
```

### **2. Environment Configuration**

Copy the example environment file and configure your deployment settings:

```bash
cp .env.example .env
```

Edit the `.env` file with your network-specific configuration:

```bash
# Sepolia configuration (optional)
ARB_SEPOLIA_FUNDED_ADDRESS=your_sepolia_wallet_address
ARB_SEPOLIA_FUNDED_PK=your_sepolia_private_key

# Local testnode configuration (optional)
ARB_LOCAL_FUNDED_ADDRESS=your_sepolia_wallet_address
ARB_LOCAL_FUNDED_PK=your_local_private_key
```

!!! warning "Private Key Security"

    Never commit your `.env` file to version control. Ensure it's listed in `.gitignore`.

---

## **🚀 Deployment Commands**

### **Local Testnode Deployment**

Deploy to your local Arbitrum testnode:

```bash
npm run deploy:local
```

Or run the deployment script directly:

```bash
npx hardhat run scripts/deploy/deploy-cache-manager-automation.ts --network localArb
```

**Expected Output:**

```json
📊 Deployment Summary:
{
  "network": "localArb",
  "cacheManagerAutomation": "0xA6E41fFD769491a42A6e5Ce453259b93983a22EF",
  "deployer": "0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E",
  "timestamp": "2025-07-17T23:04:10.642Z"
}
```

### **Arbitrum Sepolia Deployment**

Deploy to Arbitrum Sepolia testnet:

```bash
npm run deploy:sepolia
```

Or run the deployment script directly:

```bash
npx hardhat run scripts/deploy/deploy-cache-manager-automation.ts --network arbitrumSepolia
```

**Expected Output:**

```json
📊 Deployment Summary:
{
  "network": "arbitrumSepolia",
  "cacheManagerAutomation": "0x1B38ABF292a39F659916A9e7074aB1C3407196A9",
  "deployer": "0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E",
  "timestamp": "2025-07-17T23:04:54.430Z"
}
```

!!! success "Deployment Success"

    Congratulations! Your Cache Manager Automation contracts are now deployed and ready to use.

---

## **🔧 Custom Network Configuration**

To add support for additional Arbitrum-compatible networks, modify these files:

### **Deployment Configuration**

Edit `config/deployment-config.ts` to add new network configurations:

```typescript
export const deploymentConfigs = {
  // Add your custom network here
  customNetwork: {
    cacheManagerAddress: CACHE_MANAGER_ADDRESSES.customNetwork,
    arbWasmCacheAddress: ARB_WASM_CACHE_ADDRESSES.customNetwork,
    maxContractsPerUser: DEFAULT_CONFIG.maxContractsPerUser,
    maxUserFunds: DEFAULT_CONFIG.maxUserFunds,
    upgradeDelay: DEFAULT_CONFIG.upgradeDelay,
    verify: true,
    // ... other configuration
  },
};
```

### **Constants Configuration**

Update `config/constants.ts` with network-specific constants:

```typescript
// Contract addresses by network
export const CACHE_MANAGER_ADDRESSES = {
  arbitrumOne: '0x51dedbd2f190e0696afbee5e60bfde96d86464ec',
  arbitrumSepolia: '0x0c9043d042ab52cfa8d0207459260040cca54253',
  localArb: '0x0f1f89aaf1c6fdb7ff9d361e4388f5f3997f12a8',
  customNetwork: '0x0000000000000000000000000000000000000000',
};

export const ARB_WASM_CACHE_ADDRESSES = {
  arbitrumOne: '0x0000000000000000000000000000000000000072',
  arbitrumSepolia: '0x0000000000000000000000000000000000000072',
  localArb: '0x0000000000000000000000000000000000000072',
  customNetwork: '0x0000000000000000000000000000000000000072',
};
```

### **CustomNetwork Deployment**

For deploying the CMA contracts into your custom network you can run

```
npx hardhat run scripts/deploy/deploy-cache-manager-automation.ts --network customNetwork

```

---

## **📋 Post-Deployment Steps**

After successful deployment:

1. **📝 Save Contract Addresses:** Note the deployed contract addresses for configuration
2. **🔗 Update Configuration:** Use the addresses in your backend and frontend configuration
3. **✅ Verify Deployment:** Check contract verification on block explorers (if applicable)

### **Return to Root Directory**

```bash
cd ../../
```

---

## **🔧 Next Steps**

With your contracts deployed, proceed to:

1. **[Configure ThirdWeb Engine](third-web-engine.md)** - Set up automation services
2. **[SCM UI Backend](scm-ui-backend.md)** - Configure the backend API
