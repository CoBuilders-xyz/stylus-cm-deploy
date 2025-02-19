# Development Notes

## RPC Cheatsheet

### Useful Envs

```
# RPC URLS
export ARBONE_RPC="https://arb1.arbitrum.io/rpc"
export ARBNOV_RPC="https://nova.arbitrum.io/rpc"
export ARBSEP_RPC="https://sepolia-rollup.arbitrum.io/rpc"
export ARBLOC_RPC="http://localhost:8547"
export L1LOC_RPC="http://localhost:8545"

# Cache Manager Addresses
export ARBONE_CM=0x51dedbd2f190e0696afbee5e60bfde96d86464ec
export ARBNOV_CM=0x20586f83bf11a7cee0a550c53b9dc9a5887de1b7
export ARBSEP_CM=0x0c9043d042ab52cfa8d0207459260040cca54253
export ARBLOC_CM=0x0f1f89aaf1c6fdb7ff9d361e4388f5f3997f12a8

# Nitro Testnode Pre-funded Account
export ARBPRE_ADD=0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E
export ARBPRE_PK=0xdc04c5399f82306ec4b4d654a342f40e2e0620fe39950d967e1e574b32d4dd36

# Nitro Testnode L2Owner Account
export ARBLOC_OWNER_PK=0xdc04c5399f82306ec4b4d654a342f40e2e0620fe39950d967e1e574b32d4dd36
```

!!! tip "Define Envs for easier interactions"

    Set the following envs depending on the environment selected to invoque the commands easier.

    ```
    export RPC=$ARBLOC_RPC
    export ACC_PK=$ARBPRE_PK
    export ACC_ADD=$ARBPRE_ADD
    export CM_ADD=$ARBLOC_CM
    export SC_ADD=0x3bee4d202b6eb7fd4f0f7ab4ca0c3c81af619a6a
    ```

### Install Cargo Cli

Install [Rust](https://www.rust-lang.org/tools/install), and then install the Stylus CLI tool with Cargo

```bash
cargo install --force cargo-stylus cargo-stylus-check
```

Add the `wasm32-unknown-unknown` build target to your Rust compiler:

```
rustup target add wasm32-unknown-unknown
```

Then initialize a testing contract template and deploy it or use pre-loaded counter contract

```
cd src/contracts/stylus
cargo new counterTest
cd counter
cargo stylus check
cargo stylus deploy --private-key $PK --no-verify
```

!!! note "Cached Bytecode"

    For being able to cache different contracts their bytecode should be different. If the same bytecode is deployed and it's already cached the system won't allow caching.

    For generating variations of counterTest edit src/lib.rs with any change before the deploy. For instance add a new function. Alter version number to generate different onChain bytecodes
    ```
    /// Sets a number in storage to a user-specified value.
    pub fn set_number_version_1(&mut self, new_number: U256) {
        self.number.set(new_number);
    }
    ```

### Cache Manager Useful Commands

**Check rust contract before deployment**

```
cargo stylus check
```

Note: Ensure you are in the root directory of the Rust project.

**Deploy rust contract**

```
 cargo stylus deploy --private-key $ACC_PK --no-verify --endpoint=$RPC
```

Note: Ensure you are in the root directory of the Rust project.

**Activate contract**

```
 cargo stylus activate --private-key $ACC_PK --address=$SC_ADD
```

Note: Not sure how it works yet.

**Check cache manager status**

```
cargo stylus cache status --endpoint=$RPC
```

**Check specific contract status**

```
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD
```

**Suggest cache manager bid size**

stylus-cli

```
cargo stylus cache suggest-bid $SC_ADD --endpoint=$RPC
```

foundry

```
cast from-wei $(cast call $CM_ADD "getMinBid(address)(uint256)" $SC_ADD --rpc-url $RPC)
```

**Send cache manager bid**

stylus-cli

```
cargo stylus cache bid $SC_ADD $(cast to-wei 0.1)  --private-key $ACC_PK --endpoint=$RPC
```

foundry

```
cast send $CM_ADD "placeBid(address)" $SC_ADD --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0)
```

Note: if error occurs run cast decode-error <ERROR_CODE>. Already cached bytecode will return error.

### Cache Manager Admin Interactions

**Set cache manager cache size**

This command is not available on stylus-cli. Direct contract interaction is required.
Since the only chain we have access as l2 owner is local testnode the command uses ARBLOC_OWNER_PK.
Size is in bytes (1 Mb = 1000000)

```
cast send $CM "setCacheSize(uint64)" 3000000 --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

**Set cache decay rate size**

This command is not available on stylus-cli. Direct contract interaction is required.
Since the only chain we have access as l2 owner is local testnode the command uses ARBLOC_OWNER_PK.
Size is in bytes (1 Mb = 1000000)

```
cast send $CM_ADD "setDecayRate(uint64)" 0 --rpc-url $ARBLOC_RPC --private-key $ARBLOC_OWNER_PK
```

**Evict all bid entries**
Clears cache

```
cast send $CM_ADD "evictAll()" --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

**Evict K bid entries**
Evicts K bids from the cache

```
export K=1
cast send $CM_ADD "evictPrograms(uint256)" $K  --rpc-url $RPC --private-key $ARBLOC_OWNER_PK                (⎈ | docker-desktop:default)
```

**Get bid entries default getter**
Gets bid entry K from default SC getter.

```
export K=0
cast call $CM_ADD "entries(uint256)(address code,uint256 size,uint256 bid)" $K --rpc-url $RPC
```

Note: Returns error on empty cache

**Get bid entries function**
Gets all bid entries from SC function. May crash if cache is too big.

```
cast call $CM_ADD "getEntries()" --rpc-url $RPC
```

**Get smallets k bid entries function**
Gets smallest K bid entries from SC function.

```
export K=10
cast call $CM_ADD "getSmallestEntries(uint256)" $K --rpc-url $RPC
```
