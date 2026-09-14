# **Deep Dive Overview**

Stylus Manager combines two workflows with different failure modes: activation determines whether the program can execute, while caching affects the cost of repeated calls. Monitor both independently.

---

## **⚡ Activation**

Read [Activation Lifecycle](activation-lifecycle.md) for status interpretation, manual activation, automated reactivation, refunds, retry behavior, and history.

## **💰 Caching**

- [Effective Bid](effective-bid.md): how the auction accounts for time decay.
- [Bid Suggestions](bid-suggestions.md): how cache conditions affect suggested amounts.
- [Eviction Risk](eviction-risk.md): how the UI compares an existing entry with current thresholds.
- [Place Bid](place-bid.md): the direct wallet transaction and its result.
- [Cache Bid Automation](bid-automations.md): selection, independent settings, and spending controls.

## **⛽ Shared automation funding**

CMA keeps separate `biddingEnabled` and `autoActivate` controls per registered contract. Both operations use the same per-user escrow on that deployment. A bid can leave too little balance for reactivation, so track the [Gas Tank](../getting-started/stylus-cache-manager-ui/tutorials/gas-tank.md) alongside contract status.

The v2 ABI and migration changes are described in [What's New in v2](../releases/stylus-manager-v2.md).
