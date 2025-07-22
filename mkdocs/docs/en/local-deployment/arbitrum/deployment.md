# **Arbitrum Local Testnode Deployment**

The **nitro-testnode** provides a complete environment for local Arbitrum testing, including a dev-mode Geth L1 and multiple Nitro instances with different roles. This setup supports the latest Arbitrum features including Stylus smart contracts.

---

## **Prerequisites**

Before running the testnode, ensure you have the following installed:

- **bash shell**
- **docker** and **docker-compose**

All tools must be available in your PATH.

---

## **Quick Start**

### **1️⃣ Clone the Repository**

```bash
git clone -b release --recurse-submodules https://github.com/OffchainLabs/nitro-testnode.git
cd nitro-testnode
```

### **2️⃣ Initialize and Start the Node**

```bash
./test-node.bash --init
```

This command will:

- Download and set up the necessary Docker images
- Initialize the blockchain state
- Start the local Arbitrum testnode

### **3️⃣ Access the Testnode**

Once running, the **sequencer** container provides access to the testchain:

- **HTTP RPC**: `http://localhost:8547`
- **WebSocket RPC**: `ws://localhost:8548`

---

## **Available Options**

To see all available configuration options:

```bash
./test-node.bash --help
```

---

## **Important Notes**

- The testnode runs with a local L1 (Geth) in development mode
- All accounts and contracts are pre-funded for testing
- The blockchain state resets each time the testnode is restarted
- This is intended for local development and testing only

---

## **Node Data and Configuration**

For detailed information about accounts, contracts, and network configuration, see the **[Test Node Data](test-node-data.md)** section.

---

## **Further Reading**

For comprehensive documentation, advanced configuration options, and troubleshooting:

- **Official Repository**: [https://github.com/OffchainLabs/nitro-testnode](https://github.com/OffchainLabs/nitro-testnode)
- **Nitro Documentation**: [https://github.com/OffchainLabs/nitro](https://github.com/OffchainLabs/nitro)
