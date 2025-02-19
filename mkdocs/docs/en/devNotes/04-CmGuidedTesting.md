# Development Notes

Please refer to first section on [Cache Manager Interactions](/devNotes/03-cacheManagerInteractions) to set the envs properly.

## Deploy and cache with stylus-cli

Go to counterTest rust project

```
cd src/contracts/stylus/counterTest
```

Deploy the contract

```
cargo stylus deploy --private-key $ACC_PK --no-verify --endpoint=$RPC
```

Set Contract Address as ENV

```
export SC_ADD=<CONTRACT_ADDRESS>
```

Cache the contract with stylus-cli

```
cargo stylus cache bid $SC_ADD $(cast to-wei 0.001)  --private-key $ACC_PK --endpoint=$RPC
```

## Deploy and cache with foundry

Deploy Vending Machine Contract

```
forge create --rpc-url $RPC --private-key $ACC_PK src/contracts/solidity/VendingMachine.sol:VendingMachine --broadcast

```

Set Contract Address as ENV

```
export SC_ADD=<CONTRACT_ADDRESS>
```

Test the contract

```
cast call $SC_ADD "getCupcakeBalanceFor(address)" $ACC_ADD --rpc-url $RPC
```

Cache the contract with stylus-cli

```
cargo stylus cache bid $SC_ADD $(cast to-wei 0.001)  --private-key $ACC_PK --endpoint=$RPC
```

!!! warning "Stylus activate issue"

    Checking if contract can be cached...

    Error: stylus cache place bid failed
    Caused by:
    Your Stylus contract is not yet activated. To activate it, use the `cargo stylus activate` subcommand

Cache the contract with foundry

```
cast send $CM_ADD "placeBid(address)" $SC_ADD --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0.001)
```

!!! warning "Stylus activate issue"

    Error: server returned an error response: error code 3: execution reverted: error ProgramNotActivated(), data: "0x6f809c4e"

## Fill The Cache

Set the cache size to 2.1MBs

```
cast send $CM_ADD "setCacheSize(uint64)" 2100000 --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

Get the cache size

```
cast call $CM_ADD "cacheSize()(uint256)" --rpc-url $RPC
```

If some contracts are cached, evict all for clean start

```
cast send $CM_ADD "evictAll()" --rpc-url $RPC --private-key $ARBLOC_OWNER_PK
```

Check cache status

```
cargo stylus cache status --endpoint=$RPC
```

Deploy three variations of the counter test contract. For each deployment, modify the function version to ensure unique bytecode, which is necessary for caching. (filepath: src/contracts/stylus/counterTest/src/lib.rs)

1. First Deployment:

   ```rust
   /// Sets a number in storage to a user-specified value.
   pub fn set_number_version_0(&mut self, new_number: U256) {
       self.number.set(new_number);
   }
   ```

2. Second Deployment:

   ```rust
   /// Sets a number in storage to a user-specified value.
   pub fn set_number_version_1(&mut self, new_number: U256) {
       self.number.set(new_number);
   }
   ```

3. Third Deployment:
   ```rust
   /// Sets a number in storage to a user-specified value.
   pub fn set_number_version_2(&mut self, new_number: U256) {
       self.number.set(new_number);
   }
   ```

Deploy each variation using the following command:

```bash
cargo stylus deploy --private-key $ACC_PK --no-verify --endpoint=$RPC
```

Remember to keep the addresses for the next steps.

```
export SC_ADD_0=b034a5b82f12023017285b36a3d831698caa064f
export SC_ADD_1=457f2a773d9ebd5eadd5d014db162749a1ea92eb
export SC_ADD_2=72bd809045fd546c7e8dd11a26fd50805e7be5c5
```

Cache contract 0 bidding 0.001 ETH.

```
cast send $CM_ADD "placeBid(address)" $SC_ADD_0 --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0.001)
```

Verify cache status for checking for the space consumed.

```
cargo stylus cache status --endpoint=$RPC

```

Bids of value = 0 are still available since cache is not at capacity, let's cache contract 1 bidding 0.05 ETH

```
cast send $CM_ADD "placeBid(address)" $SC_ADD_1 --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0.05)
```

Verify cache status for checking for the space consumed.

```
cargo stylus cache status --endpoint=$RPC
```

Bids of value = 0 are still available since cache is not at capacity, let's try to cache contract 2 bidding 0 ETH

```
cast send $CM_ADD "placeBid(address)" $SC_ADD_2 --rpc-url $RPC --private-key $ACC_PK --value $(cast to-wei 0)
```

Now we get an error since the size of our contract exceeds the available space in the cache. We need to bid higher to evict lower bids from the heap and make space.

```
cast decode-error 0xdf370e48000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000038d7ea4c68000
```

Note: BidTooSmall

Lets get suggested bid using stylus-cli

```
cargo stylus cache suggest-bid $SC_ADD_2 --endpoint=$RPC
```

And lets try to bid using that value

```
cast send $CM_ADD "placeBid(address)" $SC_ADD_2 --rpc-url $RPC --private-key $ACC_PK --value  1000000000000000

```

Now lets check which contracts are cached

```
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD_0
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD_1
cargo stylus cache status --endpoint=$RPC --address=$SC_ADD_2

```

We can see that lower bid was evicted from the list (SC_ADD_0 with a 0.001 ETH bid)
