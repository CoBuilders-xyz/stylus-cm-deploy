# Development Notes

## Cache Manager Contract

[Cache Manager Contract - ARB Github](https://github.com/OffchainLabs/nitro-contracts/blob/94999b3e2d3b4b7f8e771cc458b9eb229620dd8f/src/chain/CacheManager.sol#L4)

## Run local nitro-testnode

```
git submodule update --init --recursive # If submodules were not downloaded yet

cd submodules/nitro-testnode

./test-node.bash --init
```

### Useful address on testnode

- **Prefunded Account Add**:

```
0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E
```

- **Prefunded Account Pk**:

```
0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659
```

- **RollupProxy**:

```
0x7d98BA231d29D5C202981542C0291718A7358c63
```

- **Inbox (proxy)**:

```
0x9f8c1c641336A371031499e3c362e40d58d0f254
```

- **Outbox (proxy)**:

```
0x50143333b44Ea46255BEb67255C9Afd35551072F
```

- **RollupEventInbox (proxy)**:

```
0x0e73Faf857E1ca53E700856fCf19F31F920a1e3c
```

- **ChallengeManager (proxy)**:

```
0x784FC11476F3d06801A76b944795E6367391b12e
```

- **AdminProxy**:

```
0x2A1f38c9097e7883570e0b02BFBE6869Cc25d8a3
```

- **SequencerInbox (proxy)**:

```
0x18d19C5d3E685f5be5b9C86E097f0E439285D216
```

- **Bridge (proxy)**:

```
0x5eCF728ffC5C5E802091875f96281B5aeECf6C49
```

- **ValidatorUtils**:

```
0xa80482dDdB7F8B9DcC24A1cd13488E3379a14568
```

- **ValidatorWalletCreator**:

```
0x92f58045FFB1C00a7b9486B9D2a55d316380CB45
```

- **CacheManager created at**:

```
0x217788c286797D56Cd59aF5e493f3699C39cbbe8
```

- **ProxyAdmin created at**:

```
0x7DD3F2a3fAeF3B9F2364c335163244D3388Feb83
```

- **TransparentUpgradeableProxy created at**:

```
0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8
0x217788c286797D56Cd59aF5e493f3699C39cbbe8
0x7DD3F2a3fAeF3B9F2364c335163244D3388Feb83
```

- **CacheManager deployed at**:

```
0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8
```

## RPC Cheatsheet

- Get account balance

```
cast balance 0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E --rpc-url http://localhost:8547
```

- Deploy EVM VendingMachine contract

```
forge create --rpc-url http://localhost:8547 --private-key 0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659 src/contracts/evmContracts/VendingMachine.sol:VendingMachine --broadcast

cast call <CONTRACT_ADDRESS> "getCupcakeBalanceFor(address)" 0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E --rpc-url http://localhost:8547
```

!!! warning "Stylus activate issue"

    EVM contracts are not active by default. Couldn't activate them with cargo stylus.
    Non active contracts cant be cached. See `cargo stylus activate`

- Deploy WASM Counter contract

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
cd src/contracts/stylusContracts
cargo new --minimal counter
cd counter
cargo stylus check
cargo stylus deploy --private-key 0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659 --no-verify
```

!!! note "Cached Bytecode"

    For being able to cache different contracts their bytecode should be different. If the same bytecode is deployed and it's already cached the system won't allow caching.

    For generating variations of counterTest edit src/lib.rs with any change before the deploy. For instance add a variable to any function
    ```
    /// Sets a number in storage to a user-specified value.
    pub fn set_number(&mut self, new_number: U256) {
        self.number.set(new_number);
        let variable = 1
    }
    ```

### INTERACT WITH CACHE MANAGER

Get Min Bid For Contract
cast call 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 "getMinBid(address)" 0x1294b86822ff4976bfe136cb06cf43ec7fcf2574 --rpc-url http://localhost:8547
cargo stylus cache bid --private-key 0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659 0x75e0e92a79880bd81a69f72983d03c75e2b33dc8 0

Place Bid For Contract
cast send 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 "placeBid(address)" 0x47cec0749bd110bc11f9577a70061202b1b6c034 --rpc-url http://localhost:8547 --private-key 0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659 --value $(cast to-wei 0)
