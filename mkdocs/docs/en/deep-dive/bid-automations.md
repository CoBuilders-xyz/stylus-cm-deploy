---
icon: material/autorenew
---

# **Cache Bid Automation**

Automated bidding registers a spending policy with **CacheManagerAutomation (CMA)**. The backend periodically selects eligible contracts and submits batches; CMA validates the requests and spends from each user's escrow.

It can place an initial cache bid or re-cache an evicted program. It skips entries that are already cached and does not guarantee continuous cache membership.

## **Independent configuration in v2**

| Setting | Purpose |
| --- | --- |
| `biddingEnabled` | Allows automated cache bids. |
| `maxBid` | Caps the value of a single automated bid. Must satisfy CMA's `minMaxBidAmount`. |
| `autoActivate` | Independently allows reactivation after expiry or a required upgrade. |
| `maxActivationCost` | Caps the value reserved for an activation attempt. |

The UI preserves activation fields when updating bidding, and preserves bidding fields when updating activation. Turning off bidding leaves auto-activation unchanged. Removing the CMA registration removes both settings.

The [Gas Tank](../getting-started/stylus-cache-manager-ui/tutorials/gas-tank.md) is shared by both operations for the same user and CMA deployment. On-chain limits such as `minFundAmount`, `maxUserFunds`, `minMaxBidAmount`, and `maxContractsPerUser` are owner-configurable; read them from your deployment.

## **Selection and execution**

The worker runs on a periodic schedule, every minute in this release. For each enabled network, it reads registered configurations and current cache parameters. It excludes invalid addresses, cached codehashes, disabled bidding, failed reads, and bids below the current minimum.

The backend does not reserve user funds during bid selection. CMA performs the final escrow check immediately before execution, along with registration, current minimum, cache membership, and duplicate-request checks. A selection does not prove that a bid will be executed.

### **Below the cache threshold**

When utilization is below `cacheThreshold`, the strategy calculates a **0 ETH** bid. This avoids automated users bidding against one another while there is room. If the current minimum for the program is positive, the zero-value bid does not qualify and is skipped.

The default threshold is **98%**, but the owner can change it. Free space percentage alone is not proof that a particular program fits.

### **At or above the threshold**

The strategy calculates:

```text
candidate = minBid + decayRate × horizonSeconds + bidIndex × bidIncrement
bidValue = min(candidate, userMaxBid)
```

If the capped value is below the current minimum, CMA skips the bid. The horizon is a calculation input, not a promised period of cache retention. New bids, auction demand, and decay continue to affect the entry after confirmation.

For user-facing suggested bids and eviction risk, see [Bid Suggestions](bid-suggestions.md). Those suggestions are separate from this automation strategy.

## **Escrow handling**

A successful paid bid consumes its value from the user's escrow. A zero-value bid does not withdraw operation value. If a paid CacheManager call fails after withdrawal, CMA restores the value to the user's escrow and reports the error. One user's funds are not used for another user's bid.

Users can call `withdrawBalance()` to withdraw their full unused balance through CMA. The internal escrow supports partial operation withdrawals, but that is different from a user-facing partial-withdrawal feature.

## **Why an enabled contract might not be cached**

| Observation | Check |
| --- | --- |
| No new bid history | It may already be cached or the next worker cycle has not run. |
| Uncached and inactive | Restore activation first. |
| Minimum exceeds maximum | Review the current auction and your per-bid limit. |
| Insufficient balance | Other bids or activations may have used the shared Gas Tank. |
| No worker activity | Check the operator's `CMA_AUTOMATION_ENABLED`, Engine, and RPC configuration. |
| Selected but not executed | Review the transaction events; on-chain conditions may have changed. |

Enable [alerts](../getting-started/stylus-cache-manager-ui/tutorials/alerts.md) and check the actual cache state and bid history after recovery. Use the [screenshot-guided setup](../getting-started/stylus-cache-manager-ui/tutorials/bid-automation.md) to configure a contract.
