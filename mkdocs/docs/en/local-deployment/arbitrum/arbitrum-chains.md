# **Arbitrum Chains**

Complete reference for all Arbitrum chains with RPC endpoints, Cache Manager addresses, and essential configuration data.

---

## **Chain Information**

=== "Arbitrum One"

    ### **Network Details**
    ```yaml
    CHAIN_ID: 42161
    NETWORK_NAME: Arbitrum One
    CURRENCY: ETH
    TECH_STACK: Nitro (Rollup)
    ```

    ### **RPC Endpoints**
    ```yaml
    HTTP_RPC: https://arb1.arbitrum.io/rpc
    WEBSOCKET_RPC: wss://arb1-feed.arbitrum.io/feed
    SEQUENCER_ENDPOINT: https://arb1-sequencer.arbitrum.io/rpc
    ```

    ### **Cache Manager**
    ```yaml
    CACHE_MANAGER: 0x51dedbd2f190e0696afbee5e60bfde96d86464ec
    ```

    ### **Precompiles**
    ```yaml
    ARBWASM_PRECOMPILE: 0x0000000000000000000000000000000000000071
    ARBWASMCACHE_PRECOMPILE: 0x0000000000000000000000000000000000000072
    ```

    ### **Block Explorers**
    - **Arbiscan**: [https://arbiscan.io/](https://arbiscan.io/)
    - **Blockscout**: [https://arbitrum.blockscout.com/](https://arbitrum.blockscout.com/)

=== "Arbitrum Nova"

    ### **Network Details**
    ```yaml
    CHAIN_ID: 42170
    NETWORK_NAME: Arbitrum Nova
    CURRENCY: ETH
    TECH_STACK: Nitro (AnyTrust)
    ```

    ### **RPC Endpoints**
    ```yaml
    HTTP_RPC: https://nova.arbitrum.io/rpc
    WEBSOCKET_RPC: wss://nova-feed.arbitrum.io/feed
    SEQUENCER_ENDPOINT: https://nova-sequencer.arbitrum.io/rpc
    ```

    ### **Cache Manager**
    ```yaml
    CACHE_MANAGER: 0x20586f83bf11a7cee0a550c53b9dc9a5887de1b7
    ```

    ### **Precompiles**
    ```yaml
    ARBWASM_PRECOMPILE: 0x0000000000000000000000000000000000000071
    ARBWASMCACHE_PRECOMPILE: 0x0000000000000000000000000000000000000072
    ```

    ### **Block Explorers**
    - **Arbiscan**: [https://nova.arbiscan.io/](https://nova.arbiscan.io/)
    - **Blockscout**: [https://arbitrum-nova.blockscout.com/](https://arbitrum-nova.blockscout.com/)

=== "Arbitrum Sepolia"

    ### **Network Details**
    ```yaml
    CHAIN_ID: 421614
    NETWORK_NAME: Arbitrum Sepolia (Testnet)
    CURRENCY: ETH
    TECH_STACK: Nitro (Rollup)
    ```

    ### **RPC Endpoints**
    ```yaml
    HTTP_RPC: https://sepolia-rollup.arbitrum.io/rpc
    WEBSOCKET_RPC: wss://sepolia-rollup.arbitrum.io/feed
    SEQUENCER_ENDPOINT: https://sepolia-rollup-sequencer.arbitrum.io/rpc
    ```

    ### **Cache Manager**
    ```yaml
    CACHE_MANAGER: 0x0c9043d042ab52cfa8d0207459260040cca54253
    ```

    ### **Precompiles**
    ```yaml
    ARBWASM_PRECOMPILE: 0x0000000000000000000000000000000000000071
    ARBWASMCACHE_PRECOMPILE: 0x0000000000000000000000000000000000000072
    ```

    ### **Block Explorers**
    - **Arbiscan**: [https://sepolia.arbiscan.io/](https://sepolia.arbiscan.io/)
    - **Blockscout**: [https://arbitrum-sepolia.blockscout.com/](https://arbitrum-sepolia.blockscout.com/)

    ### **Faucets**
    - **Sepolia ETH Faucet**: [Placeholder - Add faucet URL]
    - **Arbitrum Sepolia Faucet**: [Placeholder - Add faucet URL]

=== "Local Testnode"

    ### **Network Details**
    ```yaml
    CHAIN_ID: 412346
    NETWORK_NAME: Local Arbitrum Testnode
    CURRENCY: ETH
    TECH_STACK: Nitro (Rollup)
    ```

    ### **RPC Endpoints**
    ```yaml
    HTTP_RPC: http://localhost:8547
    WEBSOCKET_RPC: ws://localhost:8548
    L1_RPC: http://localhost:8545
    ```

    ### **Cache Manager**
    ```yaml
    CACHE_MANAGER: 0x0f1f89aaf1c6fdb7ff9d361e4388f5f3997f12a8
    ```

    ### **Precompiles**
    ```yaml
    ARBWASM_PRECOMPILE: 0x0000000000000000000000000000000000000071
    ARBWASMCACHE_PRECOMPILE: 0x0000000000000000000000000000000000000072
    ```

    ### **Prefunded Accounts**
    ```yaml
    # Main prefunded account
    ADDRESS: 0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E
    PRIVATE_KEY: 0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659

    # L2 Owner account
    L2_OWNER_ADDRESS: 0x5E1497dD1f08C87b2d8FE23e9AAB6c1De833D927
    L2_OWNER_PRIVATE_KEY: 0xdc04c5399f82306ec4b4d654a342f40e2e0620fe39950d967e1e574b32d4dd36
    ```

    ### **Core Contracts**
    ```yaml
    ROLLUP_PROXY: 0x7d98BA231d29D5C202981542C0291718A7358c63
    INBOX_PROXY: 0x9f8c1c641336A371031499e3c362e40d58d0f254
    BRIDGE_PROXY: 0x5eCF728ffC5C5E802091875f96281B5aeECf6C49
    SEQUENCER_INBOX: 0x18d19C5d3E685f5be5b9C86E097f0E439285D216
    ```

---

## **Environment Variables Setup**

### **Quick Setup Commands**

=== "Arbitrum One"

    ```bash
    export RPC="https://arb1.arbitrum.io/rpc"
    export CM_ADDRESS="0x51dedbd2f190e0696afbee5e60bfde96d86464ec"
    ```

=== "Arbitrum Nova"

    ```bash
    export RPC="https://nova.arbitrum.io/rpc"
    export CM_ADDRESS="0x20586f83bf11a7cee0a550c53b9dc9a5887de1b7"
    ```

=== "Arbitrum Sepolia"

    ```bash
    export RPC="https://sepolia-rollup.arbitrum.io/rpc"
    export CM_ADDRESS="0x0c9043d042ab52cfa8d0207459260040cca54253"
    ```

=== "Local Testnode"

    ```bash
    export RPC="http://localhost:8547"
    export CM_ADDRESS="0x0f1f89aaf1c6fdb7ff9d361e4388f5f3997f12a8"
    export RPC_L1="http://localhost:8545"

    # Prefunded accounts
    export ARBPRE_ADD="0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E"
    export ARBPRE_PK="0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659"
    export ARBLOC_OWNER_PK="0xdc04c5399f82306ec4b4d654a342f40e2e0620fe39950d967e1e574b32d4dd36"
    ```

---

!!! warning

    "Security Notice" - Local testnode keys are for development only - Never use testnet keys in production - Always use environment variables for sensitive data
