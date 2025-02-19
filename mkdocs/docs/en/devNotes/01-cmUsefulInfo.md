# Development Notes

## Cache Manager Contract

[Cache Manager Contract - ARB Github](https://github.com/OffchainLabs/nitro-contracts/blob/94999b3e2d3b4b7f8e771cc458b9eb229620dd8f/src/chain/CacheManager.sol#L4)

## Arbitrum RPCs

- **Arbitrum One**: https://arb1.arbitrum.io/rpc
- **Arbitrum Nova**: https://nova.arbitrum.io/rpc
- **Arbitrum Sepolia**: https://sepolia-rollup.arbitrum.io/rpc
- **Arbitrum Local**: http://localhost:8547 (default)

## Obtain Cache Manager Address

cargo stylus cache status --endpoint=<RPC_ENDPOINT>

- **Arbitrum One**: 0x51dedbd2f190e0696afbee5e60bfde96d86464ec
- **Arbitrum Nova**: 0x20586f83bf11a7cee0a550c53b9dc9a5887de1b7
- **Arbitrum Sepolia**: 0x0c9043d042ab52cfa8d0207459260040cca54253
- **Arbitrum Local**: 0x0f1f89aaf1c6fdb7ff9d361e4388f5f3997f12a8 (not sure if it changes across != deployments)
