---
icon: material/hexagon-multiple
---

# **Bid Suggestions**

Bid suggestions help you determine the optimal bid amount for your contract's cache slot, balancing cost and eviction risk. The system provides three recommended bid levels, each corresponding to different risk tolerance levels.

---

## **What Are Bid Suggestions?**

Bid suggestions are recommended bid amounts calculated based on:

- **Contract size**: Larger contracts require higher minimum bids
- **Current cache conditions**: Utilization, eviction rate, and competitiveness
- **Risk tolerance**: How much you're willing to risk eviction vs. cost

### **The Three Risk Levels**

| Risk Level    | Multiplier | Description                                           |
| ------------- | ---------- | ----------------------------------------------------- |
| **High Risk** | 1.0x       | Minimum viable bid (bare minimum to get in the cache) |
| **Mid Risk**  | ~1.5x      | Better chance of staying cached, balanced approach    |
| **Low Risk**  | ~2.5x      | Very likely to stay cached, maximum cache retention   |

---

## **How Are Bid Suggestions Calculated?**

### **Step 1: Base Calculation**

The system starts with the minimum acceptable bid for your contract:

```typescript
// For contract size
const minBid = await cacheManager.getMinBid(contractSize);

// For specific contract address
const minBid = await cacheManager.getMinBid(contractAddress);
```

### **Step 2: Risk Multipliers**

Base multipliers are applied to the minimum bid:

- **High Risk**: `1.0x` (always equals minimum bid)
- **Mid Risk**: `1.5x` (base multiplier)
- **Low Risk**: `2.5x` (base multiplier)

### **Step 3: Dynamic Adjustments**

The mid and low risk multipliers are adjusted based on current cache statistics:

```typescript
// Calculate adjustment factors
const utilizationFactor = 1 + cacheUtilization;
const evictionFactor = 1 + Math.min(evictionRate / 10, 0.5);
const competitivenessFactor = 1 + competitiveness;

// Combine factors with weighted importance
const combinedAdjustment =
  utilizationFactor * 0.5 + evictionFactor * 0.3 + competitivenessFactor * 0.2;

// Apply to multipliers (high risk always stays 1.0x)
midRisk = baseMidRisk * combinedAdjustment;
lowRisk = baseLowRisk * combinedAdjustment;
```

---

## **Cache Statistics Impact**

The following cache metrics influence bid suggestions:

### **Utilization** (0-1)

- **What it is**: Percentage of total cache space currently in use
- **Impact**: Higher utilization → higher suggested bids
- **Example**: 90% utilization means more competition for remaining space

### **Eviction Rate** (events per day)

- **What it is**: Number of contracts evicted from cache per day (last 7 days)
- **Impact**: Higher eviction rate → higher suggested bids
- **Example**: 5 evictions/day indicates high competition

### **Competitiveness** (0-1)

- **What it is**: Combined measure of cache pressure
- **Calculation**: `Math.min((evictionRate / 5) * utilization, 1)`
- **Impact**: Higher competitiveness → higher suggested bids

---

## **Practical Example**

Suppose your contract has a minimum bid of `1,000,000 wei` and current cache conditions are:

- **Utilization**: 80% (0.8)
- **Eviction Rate**: 2 evictions/day (0.2)
- **Competitiveness**: 0.32

**Calculation:**

```
utilizationFactor = 1 + 0.8 = 1.8
evictionFactor = 1 + min(0.2/10, 0.5) = 1.02
competitivenessFactor = 1 + 0.32 = 1.32

combinedAdjustment = (1.8 * 0.5) + (1.02 * 0.3) + (1.32 * 0.2)
                   = 0.9 + 0.306 + 0.264 = 1.47
```

**Suggested Bids:**

- **High Risk**: `1,000,000 wei` (minimum bid)
- **Mid Risk**: `1,000,000 * 1.5 * 1.47 = 2,205,000 wei`
- **Low Risk**: `1,000,000 * 2.5 * 1.47 = 3,675,000 wei`

---

## **When Are Bid Suggestions Used?**

### **For Non-Cached Contracts**

When your contract is not yet in the cache, the system shows only suggested bids to help you decide how much to bid initially.

### **For Cached Contracts**

When your contract is already cached, suggested bids are used to:

- Assess your current eviction risk
- Recommend rebidding amounts if your effective bid is too low
- Compare your position against current market conditions

---

## **Best Practices**

- **Start with Mid Risk**: Good balance between cost and cache retention
- **Monitor Cache Conditions**: Higher utilization periods require higher bids
- **Consider Your Use Case**: Critical applications may warrant Low Risk bids

---

## **See Also**

- [Effective Bid](effective-bid.md) - Understanding how bids decay over time
- [Eviction Risk](eviction-risk.md) - Assessing your contract's risk level
- [Place Bid](place-bid.md) - How to actually place a bid
