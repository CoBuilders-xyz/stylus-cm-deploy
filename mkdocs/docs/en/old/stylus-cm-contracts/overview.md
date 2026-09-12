!!! info "Archived documentation"

    This page is retained as historical reference. For the current Stylus Manager release, use the [activation, caching, and deployment guides](../../index.md). Commands and architecture in archived notes may describe earlier versions.

# 🚀 Stylus Manager Automation Contracts

## 📌 Current architecture

Stylus Manager uses **CacheManagerAutomation (CMA)** and **BiddingEscrow** for automated cache bidding and reactivation. The Solidity names remain unchanged in v2.

- **Cache bid automation** is controlled by `biddingEnabled` and the per-bid `maxBid` limit.
- **Auto-activation** is controlled independently by `autoActivate` and `maxActivationCost`.
- Both features use the user's shared **Gas Tank** balance in `BiddingEscrow` on the selected deployment.
- The backend workers select eligible programs and submit transactions through **ThirdWeb Engine**. Earlier Chainlink experiments in this archive describe a previous design.

## 📚 Current guides

- [Automation contract deployment](../../local-deployment/stylus-cache-manager-ui/deploy-cma-contracts.md)
- [Cache bid automation](../../deep-dive/bid-automations.md)
- [Activation lifecycle](../../deep-dive/activation-lifecycle.md)
- [Gas Tank](../../getting-started/stylus-cache-manager-ui/tutorials/gas-tank.md)
- [v2 compatibility and audit notes](../../releases/stylus-manager-v2.md)

## 🧪 Testing

Use the test instructions shipped with the current `stylus-cm-contracts` submodule. The archived [testing notes](testing.md) describe the earlier suite and should be read in that context.
