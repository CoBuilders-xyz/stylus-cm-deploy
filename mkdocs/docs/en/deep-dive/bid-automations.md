---
icon: material/autorenew
---

# **Bid Automations**

Bid automations eliminate the need for manual bid management by automatically placing bids for your contracts when cache conditions warrant it. When you enable automation through the frontend, a sophisticated system works behind the scenes to keep your contracts cached.

---

## **What Happens When You Enable Automation**

When you set up automated bidding through the frontend, you're configuring a system that continuously monitors cache conditions, evaluates your contracts for bidding eligibility, automatically places bids when conditions are met, and manages your funds through a secure escrow system.

The automation architecture flows from your frontend configuration to backend monitoring, then to smart contract execution, and finally to cache management. This creates a seamless pipeline that handles all the complexity of cache management without requiring your constant attention.

---

## **System Components**

### **Frontend Interface**

The "Automated Bidding" section in the frontend serves as your control center where you configure which contracts to automate, set the maximum bid amounts you're willing to pay, fund your automation balance with ETH, enable or disable automation per contract, and monitor performance and fund usage. This interface abstracts away all the underlying complexity while giving you full control over your automation settings.

### **Backend Monitoring Service**

A backend service runs every minute, continuously scanning all automated contracts across all users. It checks cache utilization and market conditions, applies bidding logic to determine which contracts need bids, and submits batch transactions to the automation contract. This service acts as the brain of the automation system, making intelligent decisions about when and how much to bid.

### **Smart Contract System**

Two contracts work together to handle the automation: the CacheManagerAutomation contract manages user configurations and executes bids, while the BiddingEscrow contract securely holds user funds for automated bidding. This dual-contract architecture ensures both functionality and security.

---

## **How the Automation Logic Works**

### **Cache Utilization Monitoring**

The system activates based on cache utilization levels, but the bidding strategy changes at the 98% threshold. Below 98% utilization, the system places 0 ETH bids - you still need to bid to get cached, but the bid amount is zero since there's available cache space. Above 98% utilization, the system calculates competitive bid amounts based on market conditions.

```typescript
const CACHE_THRESHOLD = 98; // Automation threshold

if (cacheUtilization < 98) {
  bidAmount = 0; // Bid 0 ETH for free caching
} else {
  bidAmount = calculateCompetitiveBid(); // Calculate strategic bid
}
```

This approach ensures you only pay when the cache is actually competitive, while still maintaining your cache position through zero-cost bids when space is available.

### **Contract Evaluation Process**

For each automated contract, the system performs a comprehensive evaluation:

1. **Is the contract still deployed?** (address validation)
2. **Is it already cached?** (skip if already in cache)
3. **Is automation enabled?** (user configuration check)
4. **Is there sufficient balance?** (escrow funds validation)
5. **Does the calculated bid meet requirements?** (minimum bid validation)

### **Bid Amount Calculation**

When automation triggers above 98% cache utilization, the system calculates bid amounts with a specific strategy: the bid value is designed to decay down to the minimum bid in approximately one month, based on your contract size and the current decay rate.

```typescript
// Calculate bid that decays to minimum in 30 days
const targetDuration = 30 * 24 * 60 * 60; // 30 days in seconds
const calculatedBid = minBid + decayRate * targetDuration;
const finalBid = Math.min(calculatedBid, userMaxBid);
```

This calculation ensures your contract will remain competitively positioned throughout the decay period, giving you roughly a month of cache retention before needing another bid, while still respecting your spending boundaries.

---

## **Escrow and Fund Management**

### **Secure Fund Storage**

When you fund your automation, ETH is stored in a secure escrow contract with carefully designed access controls. Only the automation system can withdraw funds for bidding purposes, while you maintain complete control to withdraw unused funds at any time. Your funds are isolated per user with no cross-contamination, ensuring security and preventing any mixing of user balances.

---

## **Backend Processing Cycle**

### **Every Minute Execution**

The automation service follows a systematic process every minute. It begins by fetching all configurations to retrieve automated contracts from all users, then evaluates the current cache state by checking utilization levels. The system applies selection logic to determine which contracts need bids, groups contracts into efficient batches for processing, submits batch bid transactions to the blockchain, and monitors results to track success or failure while handling retries as needed.

### **Batch Processing Efficiency**

Instead of individual transactions, the system employs batch processing for maximum efficiency. It groups up to 50 contracts per batch transaction, significantly reducing gas costs through this batching approach. The system handles failures gracefully with built-in retry logic and provides detailed logging for complete transparency into all operations.

---

## **What You Configure vs. What Happens Automatically**

### **Your Configuration**

Through the frontend, you set the foundational parameters that guide the automation system. You specify which contract addresses to automate, define maximum bid amounts per contract, control automation enable/disable status for each contract, and provide initial funding for the escrow system.

### **Automatic Operations**

The system handles all operational aspects without your intervention. It continuously monitors market conditions and cache utilization, determines optimal bid timing based on cache conditions, calculates appropriate bid amounts within your specified limits, manages transaction execution and gas optimization, tracks fund management and balance updates, and implements comprehensive error handling with retry logic.

---

## **Automation Benefits**

### **24/7 Monitoring**

The system provides continuous surveillance of cache conditions, ensuring immediate response when bidding is needed without requiring any manual intervention on your part. This round-the-clock monitoring means you never miss opportunities or face unexpected evictions.

### **Optimized Timing**

The automation employs smart activation that only triggers when cache conditions are truly competitive, uses efficient batch processing for significant cost savings, and implements retry logic for failed transactions to ensure reliability.

### **Risk Management**

The system maintains controlled spending within your predefined limits, provides secure fund storage in the escrow contract, and ensures transparent operations with comprehensive logging of all activities.

---

## **Best Practices**

### **Funding Strategy**

Maintain an adequate balance in your escrow, typically 2-3 times your maximum bid amount, to ensure uninterrupted service. Monitor your fund consumption patterns to understand your usage and set up balance alerts for low funds to avoid service interruptions.

### **Configuration Management**

Start with conservative maximum bid amounts and adjust based on performance data. Enable automation selectively for your most critical contracts only, and review performance regularly to make informed adjustments to your settings.

### **Cost Optimization**

Use mid-risk bid amounts for a balanced approach between cost and safety. Monitor cache competition levels and adjust your strategy accordingly, and consider seasonal patterns in cache usage that might affect your bidding strategy.

---

## **See Also**

- [Place Bid](place-bid.md) - Understanding the manual bidding process
- [Bid Suggestions](bid-suggestions.md) - How optimal bid amounts are calculated
- [Eviction Risk](eviction-risk.md) - Monitoring your contract's cache status
