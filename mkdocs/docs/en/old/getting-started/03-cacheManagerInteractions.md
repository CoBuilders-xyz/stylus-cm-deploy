!!! info "Archived documentation"

    This page is retained as historical reference. For the current Stylus Manager release, use the [activation, caching, and deployment guides](../../index.md). Commands and architecture in archived notes may describe earlier versions.

# **📜 RPC Cheatsheet**

## 🔹 **Useful Environment Variables**

### **RPC URLs**

```bash
export ARBONE_RPC="https://arb1.arbitrum.io/rpc"
export ARBNOV_RPC="https://nova.arbitrum.io/rpc"
export ARBSEP_RPC="https://sepolia-rollup.arbitrum.io/rpc"
export ARBLOC_RPC="http://localhost:8547"
export L1LOC_RPC="http://localhost:8545"
```

### **CacheManager Addresses**

```bash
export ARBONE_CM=0x51dedbd2f190e0696afbee5e60bfde96d86464ec
export ARBNOV_CM=0x20586f83bf11a7cee0a550c53b9dc9a5887de1b7
export ARBSEP_CM=0x0c9043d042ab52cfa8d0207459260040cca54253
export ARBLOC_CM=0x0f1f89aaf1c6fdb7ff9d361e4388f5f3997f12a8
```

### **Nitro Testnode Accounts**

#### **Pre-funded Account**

```bash
export ARBPRE_ADD=0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E
export ARBPRE_PK=0xdc04c5399f82306ec4b4d654a342f40e2e0620fe39950d967e1e574b32d4dd36
```

#### **L2 Owner Account**

```bash
export ARBLOC_OWNER_PK=0xdc04c5399f82306ec4b4d654a342f40e2e0620fe39950d967e1e574b32d4dd36
```

!!! Tip "Define environment variables for easier interactions"

    ```bash
    export RPC=$ARBLOC_RPC
    export ACC_PK=$ARBPRE_PK
    export ACC_ADD=$ARBPRE_ADD
    export CM_ADD=$ARBLOC_CM
    ```

---

## **🚀 Install Cargo CLI**

### **1️⃣ Install Rust & Stylus CLI**

Install [Rust](https://www.rust-lang.org/tools/install) and then install the Stylus CLI tool:

```bash
cargo install --force cargo-stylus cargo-stylus-check
```

### **2️⃣ Add Wasm Target**

```bash
rustup target add wasm32-unknown-unknown
```

### **3️⃣ Initialize & Deploy a Contract**

```bash
cd src/contracts/stylus
cargo new counterTest
cd counter
cargo stylus check
cargo stylus deploy --private-key $ACC_PK --no-verify
```

!!! Note

    Cached bytecode must be unique. Modify `src/lib.rs` before deployment, e.g., add a function:
    ```rust
    /// Sets a number in storage to a user-specified value.
    pub fn set_number_version_1(&mut self, new_number: U256) {
        self.number.set(new_number);
    }
    ```

---

## **⚙️ CacheManager Useful Commands**

### **🔎 Check Rust Contract Before Deployment**

```bash
cargo stylus check
```

### **🚀 Deploy Rust Contract**

```bash
cargo stylus deploy --private-key $ACC_PK --no-verify --endpoint=$RPC
```

### **🔑 Activate Contract**

```bash
cargo stylus activate --private-key $ACC_PK --address=$SC_ADD
```

### **📊 Check CacheManager Status**

```bash
cargo stylus cache status --endpoint=$RPC
```

### **🔎 Check Specific Contract Status**

```bash
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD
```

### **💰 Suggest CacheManager Bid Size**

#### **Stylus CLI**

```bash
cargo stylus cache suggest-bid $SC_ADD --endpoint=$RPC
```

#### **Foundry**

```bash
cast from-wei $(cast call $CM_ADD "getMinBid(address)(uint256)" $SC_ADD --rpc-url $RPC)
```

### **💸 Send CacheManager Bid**

#### **Stylus CLI**

```bash
cargo stylus cache bid $SC_ADD $(cast to-wei 0.1) --private-key $ACC_PK --endpoint=$RPC
```

#### **Foundry**

```bash
cast send $CM_ADD "placeBid(address)" $SC_ADD --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0)
```

!!! Note

    If an error occurs, use:

    ```bash
    cast decode-error <ERROR_CODE>
    ```
    Cached bytecode will return an error if already stored.

---

## **🛠️ CacheManager Admin Interactions**

### **📦 Set Cache Size (Bytes)**

```bash
cast send $CM_ADD "setCacheSize(uint64)" 3000000 --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

### **📉 Set Cache Decay Rate**

```bash
cast send $CM_ADD "setDecayRate(uint64)" 0 --rpc-url $ARBLOC_RPC --private-key $ARBLOC_OWNER_PK
```

### **🧹 Evict All Bid Entries**

```bash
cast send $CM_ADD "evictAll()" --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

### **🗑️ Evict K Bid Entries**

```bash
export K=1
cast send $CM_ADD "evictPrograms(uint256)" $K --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

### **📜 Get Bid Entries (Default Getter)**

```bash
export K=0
cast call $CM_ADD "entries(uint256)(address code,uint256 size,uint256 bid)" $K --rpc-url $RPC
```

!!! Note "Returns an error if the cache is empty."

### **📜 Get All Bid Entries**

```bash
cast call $CM_ADD "getEntries()" --rpc-url $RPC
```

!!! Warning "May crash if the cache is too large."

### **📉 Get Smallest K Bid Entries**

```bash
export K=10
cast call $CM_ADD "getSmallestEntries(uint256)" $K --rpc-url $RPC
```
