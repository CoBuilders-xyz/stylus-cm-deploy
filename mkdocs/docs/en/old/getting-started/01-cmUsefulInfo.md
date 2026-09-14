!!! info "Archived documentation"

    This page is retained as historical reference. For the current Stylus Manager release, use the [activation, caching, and deployment guides](../../index.md). Commands and architecture in archived notes may describe earlier versions.

# **🔗 CacheManager Reference**

## 📜 **CacheManager Contract**

The CacheManager is a **core smart contract** that manages the cache bidding system on Arbitrum. It ensures contracts can **reserve cache slots**, optimizing performance and execution costs.

📌 **[View Source Code](https://github.com/OffchainLabs/nitro-contracts/blob/94999b3e2d3b4b7f8e771cc458b9eb229620dd8f/src/chain/CacheManager.sol#L4) (ARB GitHub)**

---

## 🌍 **Arbitrum RPC Endpoints**

Use the following RPC endpoints to interact with the CacheManager on different Arbitrum networks:

| **Network**             | **RPC Endpoint**                                      |
| ----------------------- | ----------------------------------------------------- |
| 🟢 **Arbitrum One**     | `https://arb1.arbitrum.io/rpc`                        |
| 🟠 **Arbitrum Nova**    | `https://nova.arbitrum.io/rpc`                        |
| 🔵 **Arbitrum Sepolia** | `https://sepolia-rollup.arbitrum.io/rpc`              |
| 🏠 **Arbitrum Local**   | `http://localhost:8547` _(default for local testing)_ |

---

## 📍 **Retrieve CacheManager Address**

To obtain the CacheManager contract address on any network, run the following command:

```sh
cargo stylus cache status --endpoint=<RPC_ENDPOINT>
```

### 🔹 **CacheManager Addresses per Network**

| **Network**             | **CacheManager Address**                    |
| ----------------------- | -------------------------------------------- |
| 🟢 **Arbitrum One**     | `0x51dedbd2f190e0696afbee5e60bfde96d86464ec` |
| 🟠 **Arbitrum Nova**    | `0x20586f83bf11a7cee0a550c53b9dc9a5887de1b7` |
| 🔵 **Arbitrum Sepolia** | `0x0c9043d042ab52cfa8d0207459260040cca54253` |
| 🏠 **Arbitrum Local**   | `0x0f1f89aaf1c6fdb7ff9d361e4388f5f3997f12a8` |
