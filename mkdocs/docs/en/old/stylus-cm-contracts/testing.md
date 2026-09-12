!!! info "Archived documentation"

    This page is retained as historical reference. For the current Stylus Manager release, use the [activation, caching, and deployment guides](../../index.md). Commands and architecture in archived notes may describe earlier versions.

# 🛠️ Stylus Manager Automation Contract Testing

These archived notes describe tests for the **CacheManagerAutomation (CMA)** smart contract. Through a series of automated tests, we verify that the contract behaves as expected under various scenarios, including **normal operation, edge cases, and error conditions**.

---

## 📌 Prerequisites

Before running the test suite, follow the instructions in **[Nitro Test Node](../getting-started/02-nitroTestNodeRunAndAddresses.md)** to deploy a fully functional **Arbitrum chain** on your local machine. This setup provides the necessary environment for testing the **Stylus Manager automation contracts**.

---

## 🧪 Testing Suite Structure

The earlier test suite followed this structure:

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
