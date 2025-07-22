## RPC Cheatsheet

- Deploy EVM VendingMachine contract

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

## Local Cache Manager Interactions

Get Min Bid For Contract

```
cast call 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 "getMinBid(address)" 0x1294b86822ff4976bfe136cb06cf43ec7fcf2574 --rpc-url http://localhost:8547
cargo stylus cache bid --private-key 0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659 0xd9bf5428c4a93aa2dedd0161f299071b9d1fec0a 0
```

Place Bid For Contract

```
cast send 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 "placeBid(address)" 0xd92773693917f0ff664f85c3cb698c33420947ff --rpc-url http://localhost:8547 --private-key 0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659 --value $(cast to-wei 0)

```

Current Cache Size

```
cast call 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 "cacheSize()" --rpc-url $ARBLOC_RPC

```

Set new Cache Size

```
cast send 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 "setCacheSize(uint64)" 3000000 --rpc-url $ARBLOC_RPC --private-key $L2OWNER_PK

```

Set new decay rate

```
cast send 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 "setDecayRate(uint64)" 0 --rpc-url $ARBLOC_RPC --private-key $L2OWNER_PK

```

Evict All

```
cast send 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 "evictAll()" --rpc-url $ARBLOC_RPC --private-key $L2OWNER_PK

```

Get Entries

```
cast call 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 "getEntries()" --rpc-url $ARBLOC_RPC
```

Get Smallest k Entries

```
cast call 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 "getSmallestEntries(uint256)" 1 --rpc-url $ARBLOC_RPC
```

Get Entry by array position

```
cast call 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 "entries(uint256)(address,uint256,uint256)" 0 --rpc-url $ARBLOC_RPC
```

Test Counter Contracts (720 KBs)
3bee4d202b6eb7fd4f0f7ab4ca0c3c81af619a6a
514adac2d6baf50b1c349658848d76a9a6ff9484
53409ae94aebf3b99a9d3cf41b8e093d0e185e20
dff854d7380cb5ac8da05b39f431907f963bdf4f
809fe0e639527a927977e64c0ed107dbf09cb248
4cef6f83ad0176094a2cf9df04edc8b730600e44
42cec64466fb0b23b9f996819cdd28d17bf4527b
54ab13583c41c68df27c13eda44bbbfeaee51ea0

Test Big Contracts ()
0xb3ab6c44b67a63836e2f315a958d3980f5950378
0x48b75b8bb49c0d566bf0a451c649105397969f76
0x2097b9e6872830dbe6769dda79df3f1927b43fde

## ARB Sepolia Cache Manager Interactions

counterTest Contract

```
deployed code at address: 0xfd5518940c627aa12b875c14de16d54fd5e038c7
deployment tx hash: 0x512e93bf6b520aa4ee080fc162a561accaa42d190300baeeb77a11ab93675428
contract activated and ready onchain with tx hash: 0x66b669ebf4e1f1073d3cc6d19f8ee914930f3ce8c944e93e89adc405d5a2b2f9
```

```
cargo stylus cache suggest-bid 0xfd5518940c627aa12b875c14de16d54fd5e038c7 --endpoint=$ARBSEP_RPC
```

```
Minimum bid for contract 0xfd55…38c7: 0 wei

cargo stylus cache bid --private-key $BCUSER_PK 0xfd5518940c627aa12b875c14de16d54fd5e038c7 0 --endpoint=$ARBSEP_RPC
Checking if contract can be cached...
Sending cache bid tx...
Successfully cached contract at address: 0xfD5518940C627aa12B875c14de16d54Fd5e038C7
Sent Stylus cache bid tx with hash: 0xc4f68e83b00618339e8132cfdb08bf0d2f7f887ca0820271a4d75d0cefd72a0f
```

## Chainlink Tests

Required envs can be sourced with

```
source src/scripts/sourceUsefulEnvs.sh
```

### Automated Counter

Deploy the contract

```
forge create --rpc-url $L1LOC_RPC --private-key $ARBPRE_PK src/contracts/solidity/CounterChainlink.sol:Counter --broadcast --constructor-args 20
```

Export contract address to env

```
export CONTRACT_ADD=<DEPLOYED CONTRACT ADDRESS>
```

Check upkeep condition

```
cast call $CONTRACT_ADD "checkUpkeep(bytes)(bool,bytes)" 0x --rpc-url $L1LOC_RPC
```

Trigger upkeep condition

```
cast send $CONTRACT_ADD "performUpkeep(bytes)" 0x --rpc-url $L1LOC_RPC --private-key $ARBPRE_PK
```

Check counter status

```
cast call $CONTRACT_ADD "counter()" 0x  --rpc-url $L1LOC_RPC --private-key $ARBPRE_PK
```

### Automated Counter @ ARB Sepolia

Address: 0xdaaA70D0884Ec86CEaE83c544963c545a4213246

### Automated CM Proxy Local

CM Address: 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8
SC To Be Cached: 0xd542490eba60e4b4d28d23c5b392b1607438f3cc

Deploy Proxy
forge create --rpc-url $ARBLOC_RPC --private-key $ARBPRE_PK src/contracts/solidity/CacheManagerAutomation.sol:CacheManagerAutomation --broadcast --constructor-args 0x0f1F89AAF1c6fDb7ff9D361E4388F5F3997f12A8 0xd542490eba60e4b4d28d23c5b392b1607438f3cc 1

Deployer: 0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E
Deployed to: 0x726dA98eA36289AA08EFCf638154DfA82F9FDEB6
Transaction hash: 0x211431dcf197d7c9d8d2a8025c64663ba9e5b91dfb2fa527a81a2020c43371b5

export CONTRACT_ADD=0xED7EC2d4d4d9a6a702769679FB5A36f55EBf197B
cast call $CONTRACT_ADD "checkUpkeep(bytes)(bool,bytes)" 0x --rpc-url $ARBLOC_RPC

cast send $CONTRACT_ADD "performUpkeep(bytes)" 0x --rpc-url $ARBLOC_RPC --private-key $ARBPRE_PK
