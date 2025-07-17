# 🚀 Deploy and Cache Contracts

!!! info "🛠 Setting Up Environment Variables"
Before proceeding, ensure you've properly set up the environment variables as outlined in the [Cache Manager Interactions](/getting-started/03-cacheManagerInteractions) section.

## ⚙️ Deploy and Cache with Stylus-CLI

### Step 1: Navigate to the Counter Test Project

```bash
cd src/contracts/stylus/counterTest
```

### Step 2: Deploy the Contract

```bash
cargo stylus deploy --private-key $ACC_PK --no-verify --endpoint=$RPC
```

### Step 3: Set Contract Address as ENV Variable

```bash
export SC_ADD=<CONTRACT_ADDRESS>
```

### Step 4: Cache the Contract

```bash
cargo stylus cache bid $SC_ADD $(cast to-wei 0.001) --private-key $ACC_PK --endpoint=$RPC
```

---

## 🔥 Deploy and Cache with Foundry

### Step 1: Deploy Vending Machine Contract

```bash
forge create --rpc-url $RPC --private-key $ACC_PK src/contracts/solidity/VendingMachine.sol:VendingMachine --broadcast
```

### Step 2: Set Contract Address as ENV Variable

```bash
export SC_ADD=<CONTRACT_ADDRESS>
```

### Step 3: Test the Contract

```bash
cast call $SC_ADD "getCupcakeBalanceFor(address)" $ACC_ADD --rpc-url $RPC
```

### Step 4: Cache the Contract with Stylus-CLI

```bash
cargo stylus cache bid $SC_ADD $(cast to-wei 0.001) --private-key $ACC_PK --endpoint=$RPC
```

!!! warning "Stylus Activation Issue"

    **Error:** Stylus cache place bid failed.
    **Cause:** Your Stylus contract is not yet activated. Use the following command to activate it:
    ```bash
        cargo stylus activate --private-key $ACC_PK --address=$SC_ADD
    ```

### Step 5: Cache the Contract with Foundry

```bash
cast send $CM_ADD "placeBid(address)" $SC_ADD --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0.001)
```

!!! warning "Stylus Activation Issue"

    **Error:** Execution reverted: `ProgramNotActivated()`.

---

## 📦 Filling the Cache

### Step 1: Set Cache Size to 2.1MB

```bash
cast send $CM_ADD "setCacheSize(uint64)" 2100000 --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

### Step 2: Verify Cache Size

```bash
cast call $CM_ADD "cacheSize()(uint256)" --rpc-url $RPC
```

### Step 3: Clear Existing Cache (If Needed)

```bash
cast send $CM_ADD "evictAll()" --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

### Step 4: Check Cache Status

```bash
cargo stylus cache status --endpoint=$RPC
```

### Step 5: Deploy Three Variations of CounterTest Contract

Modify the function version before each deployment to ensure unique bytecode (filepath: `src/contracts/stylus/counterTest/src/lib.rs`).

#### First Deployment:

```rust
pub fn set_number_version_0(&mut self, new_number: U256) {
    self.number.set(new_number);
}
```

#### Second Deployment:

```rust
pub fn set_number_version_1(&mut self, new_number: U256) {
    self.number.set(new_number);
}
```

#### Third Deployment:

```rust
pub fn set_number_version_2(&mut self, new_number: U256) {
    self.number.set(new_number);
}
```

Deploy each variation:

```bash
cargo stylus deploy --private-key $ACC_PK --no-verify --endpoint=$RPC
```

Save the deployed contract addresses:

```bash
export SC_ADD_0=<ADDRESS_0>
export SC_ADD_1=<ADDRESS_1>
export SC_ADD_2=<ADDRESS_2>
```

### Step 6: Cache Contracts with Different Bids

#### Cache Contract 0 with 0.001 ETH Bid

```bash
cast send $CM_ADD "placeBid(address)" $SC_ADD_0 --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0.001)
```

#### Check Cache Status

```bash
cargo stylus cache status --endpoint=$RPC
```

#### Cache Contract 1 with 0.05 ETH Bid

```bash
cast send $CM_ADD "placeBid(address)" $SC_ADD_1 --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0.05)
```

#### Cache Contract 2 with 0 ETH Bid (Expected to Fail Due to Size Constraints)

```bash
cast send $CM_ADD "placeBid(address)" $SC_ADD_2 --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0)
```

Expected Error:

```bash
cast decode-error 0xdf370e48...
```

!!! warning "BidTooSmall Error"

    The contract is too large for available cache space. A higher bid is required to evict lower bids and make space.

### Step 7: Get Suggested Bid and Retry

```bash
cargo stylus cache suggest-bid $SC_ADD_2 --endpoint=$RPC
```

Bid with the suggested value:

```bash
cast send $CM_ADD "placeBid(address)" $SC_ADD_2 --rpc-url $RPC --private-key $ACC_PK --value 1000000000000000
```

### Step 8: Verify Cached Contracts

```bash
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD_0
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD_1
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD_2
```

!!! success "Cache Status Update"

    The lowest bid (SC_ADD_0 with 0.001 ETH) has been evicted due to a higher competing bid.
