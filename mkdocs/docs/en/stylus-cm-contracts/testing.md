# 🛠️ Stylus Cache Manager Proxy Testing

This testing suite ensures the correctness and reliability of the **Stylus Cache Manager Automation (CMA)** smart contract. Through a series of automated tests, we verify that the contract behaves as expected under various scenarios, including **normal operation, edge cases, and error conditions**.

---

## 📌 Prerequisites

Before running the test suite, follow the instructions in **[Nitro Test Node](../getting-started/02-nitroTestNodeRunAndAddresses.md)** to deploy a fully functional **Arbitrum chain** on your local machine. This setup provides the necessary environment for testing the **Stylus Cache Manager Proxy**.

---

## 🧪 Testing Suite Structure

The test suite follows a structured format:

1. **`before` Hook:** Deploys the **CMA** on top of a pre-deployed **CacheManager (CM)** contract on the **localArb** test node.
2. **`beforeEach` Hook:** Ensures a clean state by evicting all contracts from **CM** before each test.
3. **Test Cases (`describe` Blocks):** Contains the actual test scenarios to validate different contract behaviors.

---

## 🚀 Running the Test Suite

Follow these steps to execute the tests:

### 1️⃣ Navigate to the Test Directory

```bash
cd submodules/stylus-cm-contracts
```

### 2️⃣ Install Required Dependencies

```bash
npm install
```

### 3️⃣ Run the Test Suite

```bash
npm run test
```

🎯 **Done!** The test results will indicate whether the contract behaves as expected across all defined scenarios.
