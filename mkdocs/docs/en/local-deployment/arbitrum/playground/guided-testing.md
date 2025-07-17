# **🚀 Guided Testing Workflow**

This guide walks you through deploying and caching contracts on your local Arbitrum testnode, demonstrating both Stylus and Foundry approaches with practical examples.

---

## **🛠️ Prerequisites**

Ensure you have set up the required environment variables:

```bash
export ACC_PK="0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659"
export RPC="http://localhost:8547"
export CM_ADDRESS="0x0f1f89aaf1c6fdb7ff9d361e4388f5f3997f12a8"
export ARBLOC_OWNER_PK="0xdc04c5399f82306ec4b4d654a342f40e2e0620fe39950d967e1e574b32d4dd36"
```

---

## **📝 Test Scenario 1: Basic Contract Deployment**

### **Deploy Stylus Contract**

Navigate to the counter test project:

```bash
cargo stylus new counterTest --minimal
cd counterTest
cargo stylus check --endpoint $RPC
cargo stylus deploy --endpoint $RPC --private-key $ARB_PREFUNDED_PK --no-verify
```

Deploy the contract:

```bash
cargo stylus deploy --private-key $ACC_PK --no-verify --endpoint=$RPC
```

Set the contract address:

```bash
export SC_ADD=<CONTRACT_ADDRESS>
```

### **Cache the Contract**

Cargo Stylus CLI

```bash
cargo stylus cache bid $SC_ADD $(cast to-wei 0.001) --private-key $ACC_PK --endpoint=$RPC
```

Foundry

```bash
cast send $CM_ADDRESS "placeBid(address)" $SC_ADD --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0.1)
```

---

## **📝 Test Scenario 3: Cache Competition**

This scenario demonstrates how contract eviction works when cache space is limited.

### **Setup Limited Cache**

Set cache size to 2.1MB:

```bash
cast send $CM_ADDRESS "setCacheSize(uint64)" 2100000 --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

Clear existing cache:

```bash
cast send $CM_ADDRESS "evictAll()" --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

### **Deploy Multiple Contracts**

Deploy three contract variations by modifying the function name in `counterTest/src/lib.rs`:

**Version 0:**

```rust
pub fn set_number_version_0(&mut self, new_number: U256) {
    self.number.set(new_number);
}
```

**Version 1:**

```rust
pub fn set_number_version_1(&mut self, new_number: U256) {
    self.number.set(new_number);
}
```

**Version 2:**

```rust
pub fn set_number_version_2(&mut self, new_number: U256) {
    self.number.set(new_number);
}
```

Deploy each version:

```bash
cargo stylus deploy --private-key $ACC_PK --no-verify --endpoint=$RPC
```

Save addresses:

```bash
export SC_ADD_0=<ADDRESS_0>
export SC_ADD_1=<ADDRESS_1>
export SC_ADD_2=<ADDRESS_2>
```

### **Test Cache Competition**

Cache first contract (low bid):

```bash
cast send $CM_ADDRESS "placeBid(address)" $SC_ADD_0 --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0.001)
```

Cache second contract (higher bid):

```bash
cast send $CM_ADDRESS "placeBid(address)" $SC_ADD_1 --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0.05)
```

Try to cache third contract (no bid - will fail):

```bash
cast send $CM_ADDRESS "placeBid(address)" $SC_ADD_2 --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0)
```

### **Handle Eviction**

Get suggested bid for third contract:

```bash
cargo stylus cache suggest-bid $SC_ADD_2 --endpoint=$RPC
```

Bid with suggested amount:

```bash
cast send $CM_ADDRESS "placeBid(address)" $SC_ADD_2 --rpc-url $RPC --private-key $ACC_PK --value 1000000000000000
```

### **Verify Results**

Check final cache status:

```bash
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD_0
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD_1
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD_2
```

**Expected Result:** The lowest bid (SC_ADD_0) gets evicted to make room for SC_ADD_2.

---

## **📊 Common Testing Commands**

### **Check Cache Status**

```bash
cargo stylus cache status --endpoint=$RPC
```

### **Get Bid Suggestions**

```bash
cargo stylus cache suggest-bid $SC_ADD --endpoint=$RPC
```

### **Decode Errors**

```bash
cast decode-error <ERROR_CODE>
```

### **View Cache Entries**

```bash
cast call $CM_ADDRESS "getEntries()" --rpc-url $RPC
```

---

## **📚 See Also**

- [CM Interactions](cm-interactions.md) - Detailed command reference
- [Cargo Stylus](cargo-stylus.md) - CLI documentation
