# **⚙️ Cache Manager Interactions Guide**

This guide covers two ways to interact with Arbitrum's Cache Manager: **Cargo Stylus CLI** for streamlined contract management and **Foundry** for direct contract interactions.

---

## **📋 Interaction Methods**

### **🔧 Cargo Stylus CLI**

High-level commands for contract lifecycle management and cache operations.

**Best for:** Contract deployment, quick status checks, streamlined bidding

### **🛠️ Foundry (Direct Contract Interaction)**

Direct access to CacheManager contract through `cast` commands.

**Best for:** Advanced operations, custom bidding strategies, administrative functions

---

## **🚀 Contract Deployment & Activation**

### **Check Contract Before Deployment**

```bash
cargo stylus check
```

### **Deploy Contract**

```bash
cargo stylus deploy --private-key $ACC_PK --no-verify --endpoint=$RPC
```

### **Activate Contract**

```bash
cargo stylus activate --private-key $ACC_PK --address=$SC_ADD --endpoint=$RPC
```

---

## **📊 Cache Status & Monitoring**

### **Check Overall Cache Status**

```bash
cargo stylus cache status --endpoint=$RPC
```

### **Check Specific Contract Status**

```bash
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD
```

---

## **💰 Cache Bidding Operations**

### **Get Bid Suggestions**

**Cargo Stylus CLI:**

```bash
cargo stylus cache suggest-bid $SC_ADD --endpoint=$RPC
```

**Foundry:**

```bash
cast from-wei $(cast call $CM_ADDRESS "getMinBid(address)(uint256)" $SC_ADD --rpc-url $RPC)
```

### **Place a Bid**

**Cargo Stylus CLI:**

```bash
cargo stylus cache bid $SC_ADD $(cast to-wei 0.1) --private-key $ACC_PK --endpoint=$RPC
```

**Foundry:**

```bash
cast send $CM_ADDRESS "placeBid(address)" $SC_ADD --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0.1)
```

!!! tip "Error Handling"

    If an error occurs during bidding, decode it for details:

        ```bash
        cast decode-error <ERROR_CODE>
    ```

---

## **🛠️ Admin Operations**

### **Set Cache Size**

```bash
cast send $CM_ADDRESS "setCacheSize(uint64)" 3000000 --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

### **Set Cache Decay Rate**

```bash
cast send $CM_ADDRESS "setDecayRate(uint64)" 0 --rpc-url $ARBLOC_RPC --private-key $ARBLOC_OWNER_PK
```

### **Evict All Cached Contracts**

```bash
cast send $CM_ADDRESS "evictAll()" --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

### **Evict K Contracts**

```bash
export K=1
cast send $CM_ADDRESS "evictPrograms(uint256)" $K --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

---

## **📜 Cache Inspection**

### **Get Individual Cache Entry**

```bash
export K=0
cast call $CM_ADDRESS "entries(uint256)(address code,uint256 size,uint256 bid)" $K --rpc-url $RPC
```

### **Get All Cache Entries**

```bash
cast call $CM_ADDRESS "getEntries()" --rpc-url $RPC
```

!!! warning "May crash if cache is too large"

### **Get Smallest Bid Entries**

```bash
export K=10
cast call $CM_ADDRESS "getSmallestEntries(uint256)" $K --rpc-url $RPC
```

---

## **🔧 Environment Variables**

```bash
export ACC_PK="your_account_private_key"
export SC_ADD="your_contract_address"
export CM_ADDRESS="cache_manager_contract_address"
export RPC="your_rpc_endpoint"
export ARBLOC_OWNER_PK="arbitrum_owner_private_key"  # Admin only
```

---

## **🎯 Method Selection**

**Use Cargo Stylus CLI for:** Contract lifecycle, streamlined commands, cache bidding

**Use Foundry for:** Direct contract control, custom logic, admin operations

---

## **📚 See Also**

- [Guided Testing](guided-testing.md) - Step-by-step testing workflow
- [Cargo Stylus](cargo-stylus.md) - Detailed CLI documentation
