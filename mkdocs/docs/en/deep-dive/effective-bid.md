---
icon: material/book-arrow-down
---

# **Effective Bid**

The **effective bid** is the real-time value of a contract's cache slot bid after accounting for time-based decay. It determines whether a contract can retain its cache slot or risks eviction.

---

## **How is the Effective Bid Calculated?**

The effective bid decays over time according to the following formula:

```
effectiveBid = lastBid - (timeElapsed * decayRate)
```

- **lastBid**: The most recent bid amount placed for the contract (in wei)
- **timeElapsed**: Seconds since the last bid was placed
- **decayRate**: The current decay rate (in wei per second)

If the decay amount exceeds the last bid, the effective bid is set to zero.

---

## **Time Decay Bonus for New Bids**

When you place a new bid, the contract adds a **time decay bonus** to your bid. This means that for the same nominal bid value, a newer bid is always worth more than an older one, because it includes the current decay amount. This mechanism ensures that new bids are always competitive with decayed older bids.

> **Note:** As a user, you only pay the `value` you specify. The extra "decay bonus" is added by the smart contract internally for the purpose of effective bid calculation. You do **not** pay the bonus amount out of pocket—the contract logic simply makes your bid more competitive by design.

- **Placing a bid:**
  The actual bid value used for cache slot competition is:

  ```solidity
  bid = value + decay
  ```

  where `decay` is the current decay amount at the time of bidding.

- **Eviction/decay:**
  Over time, the effective value of all bids decays at the same rate, so only the relative age and size of the bid matter for eviction.

**Reference:**

- [Arbitrum CacheManager.sol on GitHub](https://github.com/OffchainLabs/nitro-contracts/blob/main/src/chain/CacheManager.sol)

Example function:

```solidity
/// @dev Converts a value to a bid by adding the time decay term.
function _toBid(uint256 value) internal view returns (uint192 bid) {
    uint256 _bid = value + _calcDecay();
    if (_bid > type(uint192).max) {
        revert BidTooLarge(_bid);
    }
    return uint192(_bid);
}
```

---

## **Why Does It Matter?**

!!! warning "Explain Better"

- The effective bid is used to determine a contract's position in the cache queue.
- If your effective bid is outbid by another contract, your contract risks eviction from the cache.
- Monitoring the effective bid is essential for understanding your place in the cache queue.

---

## **Example Calculation**

Suppose:

- `lastBid = 1,000,000 wei`
- `decayRate = 100 wei/sec`
- `timeElapsed = 3,600 sec` (1 hour)

```
decayAmount = 3,600 * 100 = 360,000 wei
effectiveBid = 1,000,000 - 360,000 = 640,000 wei
```

If the decay amount ever exceeds the last bid, the effective bid is set to `0`.

---

## **See Also**

- [Eviction Risk](eviction-risk.md)
- [Bid Suggestions](bid-suggestions.md)
