---
icon: material/arrow-collapse-down
---

# **Place Bid**

Placing a bid reserves a cache slot for your contract on Arbitrum. When you use the **"Bid Now"** feature in the frontend, you're making a direct transaction with the CacheManager contract to secure cache space for your contract.

---

## **What Happens When You Place a Bid**

When you click "Place Bid" in the frontend, the system:

1. **Validates your bid amount** against current market conditions
2. **Prepares the transaction** with the correct parameters
3. **Sends the transaction** through your wallet to the CacheManager contract
4. **Monitors the result** and updates your contract's cache status

### **The Transaction Flow**

```
Frontend → Your Wallet → CacheManager Contract → Cache Queue
```

The frontend handles all the complexity, but ultimately you're calling:

```solidity
function placeBid(address program) external payable
```

Where:

- **`program`**: Your contract address
- **`payable`**: The ETH amount you're bidding

---

## **Bid Amount Selection**

### **Suggested Bid Levels**

The frontend provides three suggested bid amounts based on current market conditions:

- **High Risk Bid**: The minimum amount needed to get into the cache
- **Mid Risk Bid**: A safer amount that's less likely to be outbid
- **Low Risk Bid**: The most secure amount for long-term cache retention

These suggestions are calculated using the same logic described in [Bid Suggestions](bid-suggestions.md).

### **Custom Bid Amounts**

You can also enter a custom bid amount, but it must be **At least the minimum bid** for your contract size.

---

## **What Happens After You Bid**

### **Immediate Effects**

1. **Transaction Confirmation**: Your bid is recorded on the blockchain
2. **Cache Queue Entry**: Your contract enters the cache queue
3. **Effective Bid Calculation**: Your bid starts with a time decay bonus
4. **Status Update**: The frontend updates to show your contract's new status

### **Time Decay Bonus**

The CacheManager contract automatically adds a "decay bonus" to your bid:

```solidity
actualBid = yourBidAmount + currentDecayAmount
```

This ensures your new bid is competitive with older bids that have been decaying. **You only pay your bid amount** - the bonus is added by the contract logic.

---

## **Monitoring Your Bid**

### **Effective Bid Tracking**

After placing a bid, your [effective bid](effective-bid.md) will decay over time:

```
effectiveBid = lastBid - (timeElapsed * decayRate)
```

### **Eviction Risk Assessment**

The system continuously monitors your [eviction risk](eviction-risk.md) by comparing your effective bid to current market thresholds.

### **Rebidding Considerations**

Since manual rebidding isn't practical for active cache management, consider:

- **Setting up eviction alerts** to know when your contract is evicted
- **Enabling bid automation** for continuous cache maintenance

---

## **See Also**

- [Effective Bid](effective-bid.md) - Understanding how your bid decays over time
- [Bid Suggestions](bid-suggestions.md) - How the system calculates recommended amounts
- [Bid Automations](bid-automations.md) - Automated bidding for continuous cache management
