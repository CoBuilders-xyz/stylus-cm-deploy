# **🔗 Cache Manager Basics**

> **Welcome!** Here's how the Cache Manager helps your contracts run faster, cheaper, and more reliably—plus how to find and use it.

---

## **📋 What is the Cache Manager?**

The **Cache Manager** is a core smart contract on Arbitrum that lets you reserve high-speed cache slots for your WASM (Stylus) contracts. Caching your contract means:

- Faster execution (no cold-start penalty)
- Lower gas costs for repeated calls
- Predictable performance for demanding dApps

But cache space is limited. To get (and keep) a slot, you must **bid**—and maintain your bid—against others. The Cache Manager enforces these rules and handles slot allocation.

---

## **🌐 Where is the Cache Manager?**

You interact with the Cache Manager contract directly on-chain. Here's how to find it:

### **RPC Endpoints**

| **Network**             | **RPC Endpoint**                                       |
| ----------------------- | ------------------------------------------------------ |
| 🟢 **Arbitrum One**     | `https://arb1.arbitrum.io/rpc`                         |
| 🟠 **Arbitrum Nova**    | `https://nova.arbitrum.io/rpc`                         |
| 🔵 **Arbitrum Sepolia** | `https://sepolia-rollup.arbitrum.io/rpc`               |
| 🏠 **Local (dev/test)** | `http://localhost:8547` _(usually for nitro-testnode)_ |

### **📍 Get the Cache Manager Address**

You can retrieve the contract address for any network using the CLI:

```bash
cargo stylus cache status --endpoint=<RPC_ENDPOINT>
```

!!! tip "Get Arbitrum Stylus Cli"

    If you dont have stylus-cli yet, you can get it following [Arbitrum docs](https://docs.arbitrum.io/stylus/using-cli)

#### **Known Addresses**

| **Network**             | **Cache Manager Address**                    |
| ----------------------- | -------------------------------------------- |
| 🟢 **Arbitrum One**     | `0x51dedbd2f190e0696afbee5e60bfde96d86464ec` |
| 🟠 **Arbitrum Nova**    | `0x20586f83bf11a7cee0a550c53b9dc9a5887de1b7` |
| 🔵 **Arbitrum Sepolia** | `0x0c9043d042ab52cfa8d0207459260040cca54253` |
| 🏠 **Local (default)**  | `0x0f1f89aaf1c6fdb7ff9d361e4388f5f3997f12a8` |

---

## **⚙️ How does it work?**

!!! tip "Quick summary"

    - You place a bid to reserve a cache slot for your contract.
    - The Cache Manager tracks all bids and enforces minimums.
    - If someone outbids you (by at least 10%), you risk eviction. - You must keep your bid funded—automation is highly recommended.

For a deeper dive into the economics and automation, see the next sections.

---

## **📚 More information**

- [**Arbitrum Docs: Caching Contracts**](https://docs.arbitrum.io/stylus/how-tos/caching-contracts)
- [**Cache Manager Source Code (GitHub)**](https://github.com/OffchainLabs/nitro-contracts/blob/main/src/chain/CacheManager.sol)

---

Ready to get hands-on?
Let's explore the UI and see how you can take control of your contract's cache slots.
