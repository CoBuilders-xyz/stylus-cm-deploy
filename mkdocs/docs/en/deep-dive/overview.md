# **Deep Dive Overview**

The Stylus Cache Manager frontend provides a user-friendly interface for interacting with the underlying cache bidding system, enhanced with additional features like automated bidding and monitoring alerts. These tools help you manage your contract's cache status more effectively than direct contract interaction.

---

## **Why These Topics Matter**

Without proper cache management, your contract risks eviction, leading to slower execution and higher gas costs. While the bidding system itself doesn't prevent eviction, understanding how to use these tools effectively - especially automation - can help maintain your cache position.

---

## **Essential Concepts**

### **[Effective Bid](effective-bid.md)**

Your bid's real-time value after time-based decay. This determines whether your contract stays cached or gets evicted.

### **[Bid Suggestions](bid-suggestions.md)**

Smart recommendations for bid amounts based on three risk levels: High , Mid , and Low multipliers.

### **[Eviction Risk](eviction-risk.md)**

Real-time assessment of your contract's likelihood of eviction, helping you take action before it's too late.

### **[Place Bid](place-bid.md)**

Direct wallet interaction with the CacheManager contract to secure cache slots for your contracts.

### **[Bid Automations](bid-automations.md)**

Automated bidding system that monitors cache conditions and places bids for you, eliminating manual management.

---

## **Start Here**

New to cache bidding? Begin with **[Effective Bid](effective-bid.md)** to understand how the decay system works, then explore **[Bid Suggestions](bid-suggestions.md)** to learn optimal bidding strategies.

Already familiar with manual bidding? Jump to **[Bid Automations](bid-automations.md)** to set up automated cache management.
