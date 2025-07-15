---
icon: material/autorenew
---

# **Bid Automations**

Bid automations eliminate the need for manual bid management by automatically placing bids for your contracts when cache conditions warrant it. When you enable automation through the frontend, a sophisticated system works behind the scenes to keep your contracts cached.

---

## **What Happens When You Enable Automation**

When you set up automated bidding through the frontend, you're configuring a system that:

1. **Monitors cache conditions** continuously
2. **Evaluates your contracts** for bidding eligibility
3. **Automatically places bids** when conditions are met
4. **Manages your funds** through a secure escrow system

### **The Automation Architecture**

```
Frontend Configuration → Backend Monitoring → Smart Contract Execution → Cache Management
```

---

## **System Components**

### **1. Frontend Interface**

The "Automated Bidding" section in the frontend allows you to:

- **Configure contracts** for automation
- **Set maximum bid amounts** you're willing to pay
- **Fund your automation balance** with ETH
- **Enable/disable automation** per contract
- **Monitor performance** and fund usage

### **2. Backend Monitoring Service**

A backend service runs every minute to:

- **Scan all automated contracts** across all users
- **Check cache utilization** and market conditions
- **Apply bidding logic** to determine which contracts need bids
- **Submit batch transactions** to the automation contract

### **3. Smart Contract System**

Two contracts work together:

- **CacheManagerAutomation**: Manages user configurations and executes bids
- **BiddingEscrow**: Securely holds user funds for automated bidding

---

## **How the Automation Logic Works**

### **Cache Utilization Monitoring**

The system only activates when the cache is nearly full:

```typescript
const CACHE_THRESHOLD = 98; // Automation starts when cache is 98% full
```

- **Below 98%**: No automated bids (cache has free space)
- **Above 98%**: Automation system activates

### **Contract Evaluation Process**

For each automated contract, the system checks:

1. **Is the contract still deployed?** (address validation)
2. **Is it already cached?** (skip if already in cache)
3. **Is automation enabled?** (user configuration)
4. **Is there sufficient balance?** (escrow funds check)
5. **Does the calculated bid meet requirements?** (minimum bid validation)

### **Bid Amount Calculation**

When automation triggers, the system calculates bid amounts designed to:

- **Maintain cache position** for approximately 30 days
- **Account for time decay** in the bid calculation
- **Stay within user limits** (never exceed max bid)

```typescript
// Simplified calculation logic
const targetDuration = 30 * 24 * 60 * 60; // 30 days in seconds
const calculatedBid = minBid + decayRate * targetDuration;
const finalBid = Math.min(calculatedBid, userMaxBid);
```

---

## **Escrow and Fund Management**

### **Secure Fund Storage**

When you fund your automation, ETH is stored in a secure escrow contract:

- **Only the automation system** can withdraw funds for bidding
- **You maintain control** to withdraw unused funds at any time
- **Funds are isolated** per user with no cross-contamination

### **Automated Fund Usage**

The system automatically:

- **Withdraws exact bid amounts** from your escrow when needed
- **Tracks fund usage** for transparency
- **Prevents overdrafts** by checking balance before bidding
- **Returns unused funds** if bids fail

---

## **Backend Processing Cycle**

### **Every Minute Execution**

The automation service follows this process:

1. **Fetch All Configurations**: Retrieve automated contracts from all users
2. **Evaluate Cache State**: Check current cache utilization
3. **Apply Selection Logic**: Determine which contracts need bids
4. **Batch Processing**: Group contracts into efficient batches
5. **Submit Transactions**: Send batch bid transactions to the blockchain
6. **Monitor Results**: Track success/failure and handle retries

### **Batch Processing Efficiency**

Instead of individual transactions, the system:

- **Groups up to 50 contracts** per batch transaction
- **Reduces gas costs** through batch processing
- **Handles failures gracefully** with retry logic
- **Provides detailed logging** for transparency

---

## **What You Configure vs. What Happens Automatically**

### **Your Configuration**

Through the frontend, you set:

- **Contract addresses** to automate
- **Maximum bid amounts** per contract
- **Automation enable/disable** status
- **Initial funding** for the escrow

### **Automatic Operations**

The system handles:

- **Market monitoring** and cache utilization tracking
- **Bid timing** based on cache conditions
- **Amount calculation** within your limits
- **Transaction execution** and gas management
- **Fund management** and balance tracking
- **Error handling** and retry logic

---

## **Monitoring and Transparency**

### **Performance Tracking**

The system provides visibility into:

- **Successful automated bids** placed for your contracts
- **Fund utilization** and remaining balance
- **Batch processing results** and success rates
- **Contract cache status** updates

### **Balance Management**

You can monitor through the frontend:

- **Current escrow balance** in real-time
- **Recent fund usage** for automated bids
- **Recommended funding levels** based on your configuration
- **Withdrawal capabilities** for unused funds

---

## **Automation Benefits**

### **24/7 Monitoring**

- **Continuous surveillance** of cache conditions
- **Immediate response** when bidding is needed
- **No manual intervention** required

### **Optimized Timing**

- **Smart activation** only when cache is competitive
- **Efficient batch processing** for cost savings
- **Retry logic** for failed transactions

### **Risk Management**

- **Controlled spending** within your limits
- **Secure fund storage** in escrow
- **Transparent operations** with full logging

---

## **Setting Up Through the Frontend**

### **Initial Configuration**

1. **Navigate to Automated Bidding** section in your contract view
2. **Set maximum bid amount** you're comfortable paying
3. **Enable automation** for the contract
4. **Fund your escrow** with initial ETH deposit

### **Ongoing Management**

- **Monitor balance** and add funds as needed
- **Adjust max bid amounts** based on market conditions
- **Enable/disable automation** as requirements change
- **Withdraw unused funds** when no longer needed

---

## **Best Practices**

### **Funding Strategy**

- **Maintain adequate balance** (2-3x your max bid)
- **Monitor fund consumption** patterns
- **Set up balance alerts** for low funds

### **Configuration Management**

- **Start with conservative** max bid amounts
- **Enable selectively** for critical contracts only
- **Review performance** regularly and adjust

### **Cost Optimization**

- **Use mid-risk bid amounts** for balanced cost/safety
- **Monitor cache competition** and adjust accordingly
- **Consider seasonal patterns** in cache usage

---

## **See Also**

- [Place Bid](place-bid.md) - Understanding the manual bidding process
- [Bid Suggestions](bid-suggestions.md) - How optimal bid amounts are calculated
- [Eviction Risk](eviction-risk.md) - Monitoring your contract's cache status
