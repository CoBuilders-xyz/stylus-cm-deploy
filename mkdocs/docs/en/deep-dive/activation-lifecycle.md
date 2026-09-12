---
icon: material/lightning-bolt
---

# **Activation Lifecycle**

Activation registers deployed WASM with **ArbWasm** for the chain's current Stylus version. Cache bidding is a separate operation. Activation can expire or become incompatible with a protocol upgrade even if the application still tracks the same address.

## **What the UI state means**

The backend reads `programTimeLeft` and decodes known ArbWasm errors. The frontend combines that reading with the last indexed activation result.

| State | Meaning | Next step |
| --- | --- | --- |
| **Active** | A valid activation is available. | Monitor remaining lifetime. |
| **Expiring** | The lifetime is within the UI's expiration window. | Review alerts and the reactivation plan. |
| **Inactive** | Never activated, expired, or requires the current Stylus version. | Inspect the reason and activate. |
| **Error** | The last indexed CMA activation failed, without a fresh positive lifetime proving recovery. | Inspect the failure and current on-chain state. |
| **Unknown** | No usable current reading or known state is available. | Retry the read; do not treat an RPC failure as proof of expiry. |

`programTimeLeft` is a string of seconds or `null`. `programTimeLeftReason` can be `never_activated`, `expired`, `needs_upgrade`, or `null`. A missing reading is distinct from zero remaining lifetime. A fresh positive reading overrides a stale automation error after manual recovery.

The UI's **Expiring** threshold and a user's **Approaching expiration** alert threshold are separate settings. Neither causes preventive keepalive.

## **Manual activation**

The wallet sends `activateProgram(address)` to ArbWasm at `0x0000000000000000000000000000000000000071`, supplying the estimated activation value and transaction gas. Fee estimation is a simulation; the receipt and refreshed lifetime establish the result.

Use manual activation for the first activation and for recovery when needed. Anyone able to pay can activate the program; they do not have to be its deployer.

## **Automated reactivation**

The backend selects registered programs periodically. Selection requires auto-activation enabled, sufficient escrow for the configured maximum, a qualifying expiry or upgrade state, and eligibility under the retry policy. Automated bidding does not have to be enabled.

Before spending, CMA checks the on-chain registration, `autoActivate`, escrow balance, and ArbWasm state again. It accepts an expired program (`programTimeLeft == 0` or `ProgramExpired`) and `ProgramNeedsUpgrade`. It skips a still-active program, `ProgramNotActivated`, and unknown read failures.

This is reactive reactivation. There may be downtime between expiry and the successful transaction.

### **Maximum cost and refunds**

CMA reserves the configured `maxActivationCost` from the user's escrow and calls ArbWasm. The Gas Tank must cover that full amount. The emitted `ActivationPerformed` event reports the data fee, value actually spent, refund, and resulting balance.

Refunds use the contract's measured balance change. Value returned by the precompile is credited back to the user's escrow; a chain that retains the full supplied value can consume the full maximum. Do not assume the data fee alone is the final charge.

If the activation call reverts, CMA restores the reserved value to escrow and emits `ActivationError` and `ActivationRevertData`. This restores the operation value; transaction gas paid by the submitting operator is separate.

### **Retry policy**

In this backend release, failed activation attempts use a backoff of **retry count × 5 minutes**. Automatic selection stops at **5 recorded retries**. A successful indexed activation resets the retry count. These are backend defaults, not protocol constants.

If retries stop, inspect the error, balance, cost limit, RPC health, and current program state. A manual activation can restore service, but its direct ArbWasm transaction does not itself create a CMA success event to reset the indexed retry history.

## **History and notifications**

**Activation History** shows CMA `ActivationPerformed` and `ActivationError` events scoped to the selected chain and contract address. Direct wallet activations can update live state without adding a CMA history row.

**Approaching expiration** and **Expired** are periodic monitoring alerts. **Reactivation succeeded** and **Reactivation failed** follow CMA events. A required upgrade is shown in the program state and handled by automation; the current expiration-alert evaluator does not explicitly classify `ProgramNeedsUpgrade` as an expired notification.

## **See also**

- [Activate a Contract](../getting-started/stylus-cache-manager-ui/tutorials/activation.md)
- [Auto-activation](../getting-started/stylus-cache-manager-ui/tutorials/auto-activation.md)
- [Full activation walkthrough](../tutorials/activation.md)
- [Arbitrum activation reference](https://docs.arbitrum.io/stylus/concepts/activation)
- [CMA v2 source](https://github.com/CoBuilders-xyz/stylus-cm-contracts/blob/d64cae8/contracts/core/CacheManagerAutomation.sol)
