---
icon: material/delete-alert
---

# **Eviction Risk**

Eviction risk assessment helps you understand how likely your contract is to be evicted from the cache based on its current effective bid compared to market conditions. This is crucial for maintaining cache reliability and avoiding unexpected gas cost increases.

---

## **What is Eviction Risk?**

Eviction risk is a measure of how vulnerable your cached contract is to being removed from the cache. It's calculated by comparing your contract's current [effective bid](effective-bid.md) against the [suggested bid levels](bid-suggestions.md) for your contract size.

> **Note:** Eviction risk is only calculated for contracts that are **already cached**. Non-cached contracts receive bid suggestions instead.

---

## **Risk Levels Explained**

### **🔴 High Risk**

- **Meaning**: Your contract is likely to be evicted soon if the cache becomes competitive
- **When it occurs**:
  - Your effective bid is below the minimum bid threshold
  - Your effective bid is above minimum but below the mid-risk threshold
- **Action needed**: **Set up eviction alerts or bid automation immediately**

### **🟡 Medium Risk**

- **Meaning**: Your contract has a reasonable chance of staying cached but could be evicted under pressure
- **When it occurs**: Your effective bid is between mid-risk and low-risk thresholds
- **Action needed**: **Monitor closely**

### **🟢 Low Risk**

- **Meaning**: Your contract will likely remain cached even under competitive conditions
- **When it occurs**: Your effective bid is above the low-risk threshold
- **Action needed**: **Continue monitoring, no immediate action needed**

---

## **How is Eviction Risk Calculated?**

### **Step 1: Calculate Effective Bid**

```typescript
const effectiveBid = lastBid - timeElapsed * decayRate;
```

### **Step 2: Get Current Market Thresholds**

The system calculates what bid amounts would be recommended right now for your contract size:

```typescript
const suggestedBids = {
  highRisk: minBid, // 1.0x minimum
  midRisk: minBid * 1.5 * adjustment, // ~1.5x adjusted
  lowRisk: minBid * 2.5 * adjustment, // ~2.5x adjusted
};
```

### **Step 3: Compare and Assign Risk Level**

```typescript
if (effectiveBid < suggestedBids.highRisk) {
  riskLevel = 'high';
} else if (effectiveBid < suggestedBids.midRisk) {
  riskLevel = 'high'; // Still high risk
} else if (effectiveBid < suggestedBids.lowRisk) {
  riskLevel = 'medium';
} else {
  riskLevel = 'low';
}
```

---

## **Understanding the Results**

When you view your contract's eviction risk, you'll see:

### **Risk Level**

Your current risk category (High/Medium/Low)

### **Remaining Effective Bid**

Your contract's current effective bid value in wei

### **Current Market Conditions**

Cache statistics that influenced the thresholds:

- **Utilization**: How full the cache is
- **Eviction Rate**: Recent eviction frequency
- **Competitiveness**: Overall market pressure

---

## **Practical Example**

Suppose your contract has:

- **Last bid**: `2,000,000 wei`
- **Placed**: 2 hours ago
- **Decay rate**: `100 wei/sec`
- **Contract size**: `1024 bytes`

**Step 1: Calculate effective bid**

```
timeElapsed = 2 hours = 7,200 seconds
decayAmount = 7,200 * 100 = 720,000 wei
effectiveBid = 2,000,000 - 720,000 = 1,280,000 wei
```

**Step 2: Current market thresholds** (assuming 1.2x adjustment)

```
highRisk = 1,000,000 wei (minimum bid)
midRisk = 1,000,000 * 1.5 * 1.2 = 1,800,000 wei
lowRisk = 1,000,000 * 2.5 * 1.2 = 3,000,000 wei
```

**Step 3: Risk assessment**

```
effectiveBid (1,280,000) < midRisk (1,800,000)
→ Risk Level: HIGH
```

---

## **When to Take Action**

### **Immediate Action (High Risk)**

- **Set up eviction alerts** to be notified when your contract is actually evicted
- **Enable bid automation** to automatically maintain your cache position
- Monitor cache conditions for optimal timing

### **Monitor Closely (Medium Risk)**

- **Check daily** for risk level changes
- **Prepare automation setup** if risk increases
- Consider enabling automation during low-competition periods

### **Regular Monitoring (Low Risk)**

- **Check weekly** or set up alerts
- **Maintain current strategy** unless conditions change dramatically
- Plan for future automation based on decay timeline

---

## **Proactive Risk Management**

### **Eviction Alerts**

Set up alerts to be notified when your contract is actually evicted from the cache, allowing you to respond quickly.

### **Bid Automation**

Enable automated bidding to maintain your cache position without manual intervention. This is the most effective way to manage eviction risk.

### **Regular Monitoring**

Use the dashboard to track your contract's risk level and effective bid decay over time.

---

## **See Also**

- [Effective Bid](effective-bid.md) - Understanding how your bid decays
- [Bid Suggestions](bid-suggestions.md) - Recommended bid amounts
- [Bid Automations](bid-automations.md) - Automated risk management
