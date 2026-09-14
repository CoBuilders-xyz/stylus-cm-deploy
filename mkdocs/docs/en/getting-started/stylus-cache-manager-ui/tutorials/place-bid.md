---
icon: material/arrow-collapse-down
---

# **💰 Place a Cache Bid**

> **Reserve cache space for an active program.** Manual bids use your connected wallet's ETH. First [activate the program](activation.md) if needed.

## **Step 1: Open the Cache tab**

In **My Contracts**, select the contract and open **Cache**. Check that the address is correct and the status is **Not Cached**.

<figure markdown="span">
  ![The recorded active program before its first cache bid.](../../../tutorials/assets/cache-platform-01-not-cached.png){ width="700" }
</figure>

## **Step 2: Review the minimum and enter a bid**

In **Bid now**, review the current suggestions and choose an amount at least equal to the current minimum. Suggestions are guidance about auction pressure, not a guaranteed cache lifetime.

<figure markdown="span">
  ![Manual bid form using the local devnode zero-value minimum.](../../../tutorials/assets/cache-platform-02-manual-bid.png){ width="700" }
</figure>

The recorded local example uses `0 ETH` because there was available space. Your network may require a positive bid. Even a zero-value bid requires transaction gas.

## **Step 3: Confirm and verify**

Select **Place Bid**, switch the wallet network if prompted, and confirm the transaction. After its receipt, verify **Cached** and the **Manual Bid** entry in **Bid History**.

<figure markdown="span">
  ![The demo contract cached after its manual bid, with bid history.](../../../tutorials/assets/cache-platform-03-manual-cached.png){ width="700" }
</figure>

Manual bidding is disabled while the codehash is already cached. If a bid fails because the auction moved, refresh the minimum before trying again. If the contract is later evicted, it can still execute while its activation remains valid.

Next: [Cache Bid Automation](bid-automation.md), [Alerts](alerts.md), or the full [caching tutorial](../../../tutorials/caching.md).
