# **🚀 Stylus Manager v2**

**Release merged to main: September 10–11, 2026.** Stylus Cache Manager becomes **Stylus Manager**, with activation and caching presented as separate workflows in one application.

This page summarizes the merged frontend, backend, and **CacheManagerAutomation v2.0.0** changes. Repository names, smart-contract names, and existing documentation URLs retain their previous identifiers.

## **What's new for users**

- **Activation workflow:** manual **Activate now**, current activation state, remaining lifetime, and reasons for inactive programs.
- **Auto-activation:** on-chain configuration, a per-attempt cost limit, automatic reactivation after expiry or a required upgrade, and automation history.
- **Independent automation:** cache bidding uses `biddingEnabled`; reactivation uses `autoActivate`. Updating one preserves the other's settings.
- **Shared Gas Tank:** automated bids and activations draw from the same user escrow within a CMA deployment.
- **Activation alerts:** approaching expiration, expired, reactivation succeeded, and reactivation failed, alongside the four existing cache alerts.
- **Refreshed UI:** separate Cache and Activation tabs, responsive contract views, search and pagination, status filters, explorer links, and a command palette.
- **Cache analytics:** 30-day insertion/deletion metrics and monthly chart views.
- **Wallet and form fixes:** consistent network checks, better activation fee estimation for low-balance wallets, validation against CMA's minimum maximum-bid setting, and preservation of unsaved maximum-bid edits during data refreshes.

Start with the [UI overview](../getting-started/stylus-cache-manager-ui/overview.md) or the new quick guides for [activation](../getting-started/stylus-cache-manager-ui/tutorials/activation.md) and [auto-activation](../getting-started/stylus-cache-manager-ui/tutorials/auto-activation.md).

<span id="upgrading-from-the-cache-manager-release"></span>

## **Upgrading to Stylus Manager v2**

### **For users**

The v2 automation contracts are new deployments. Funds and registrations in an older CMA do **not** transfer automatically. Before using v2, inspect your old deployment, disable obsolete automation, withdraw unused funds through that deployment, and configure and fund v2 on the intended chain.

The Gas Tank shown by the app belongs to the CMA address returned by its backend. A zero balance after a deployment change does not establish that an old escrow is empty. Manual activation and manual cache bidding are independent of CMA registration.

### **For operators and integrations**

1. Update frontend, backend, and contracts together from `main`; both apps expect the **v2 ABI**.
2. Configure the appropriate `ARB_*_CMA_ADDRESS`. The frontend obtains it through `/blockchains`.
3. Apply the backend schema changes for `biddingEnabled`, activation fields, and activation alert types. Staging and production run migrations at boot; local and develop use schema synchronization.
4. Inspect any previously synchronized database before migration. Baseline only migrations whose changes already exist. Run startup migrations with one application instance, or use a separate coordinated migration step.
5. Configure the independent worker switches: `CMA_AUTOMATION_ENABLED` for caching and `CMA_ACTIVATION_AUTOMATION_ENABLED` for activation. Activation automation defaults to **false** when unset.
6. Supply fast-sync RPC access tokens where required. Run one automation deployment per chain/CMA pair to avoid duplicate submissions from staging and production.
7. Verify enabled networks, contract addresses, wallet chain checks, activation reads, histories, and alert delivery before relying on automation.

See [Backend Deployment](../local-deployment/stylus-cache-manager-ui/scm-ui-backend.md) for setup and migration commands.

### **CMA ABI compatibility**

The output tuple changed:

```text
v1: (contractAddress, maxBid, enabled, autoActivate, maxActivationCost)
v2: (contractAddress, biddingEnabled, autoActivate, maxBid, maxActivationCost)
```

`insertContract` and `updateContract` still take inputs in this order:

```text
(contractAddress, maxBid, biddingEnabled, autoActivate, maxActivationCost)
```

Do not reuse the output tuple order for writes or decode v2 returns with the v1 ABI. Use the artifacts shipped with the matching contracts release.

## **Contract audit**

The contracts repository includes the [Cyfrin report dated August 31, 2026](https://github.com/CoBuilders-xyz/stylus-cm-contracts/blob/d64cae8/audits/2026-08-31-cyfrin-cobuilders-cachemanager-automation-v2.0.pdf). Its scope covers `CacheManagerAutomation.sol` and `BiddingEscrow.sol`; the repository records the audit commit and remediation commit in its [audit section](https://github.com/CoBuilders-xyz/stylus-cm-contracts/tree/d64cae8#security).

Some retained screenshots and current UI acknowledgements still say “pending audit.” That wording predates the published contract report. The report does not cover the entire frontend, backend, deployment, or ongoing operator service. Automation is still presented as experimental in the UI.

The release also adds two-step ownership transfers, stronger configuration validation, duplicate-bid prevention, safer escrow accounting, and clearer operation events and errors.

## **Release sources**

| Component | Release PR | Related changes |
| --- | --- | --- |
| Frontend | [#91: Stylus Manager v2](https://github.com/CoBuilders-xyz/stylus-cm-frontend/pull/91) | [#93: release review fixes](https://github.com/CoBuilders-xyz/stylus-cm-frontend/pull/93), [#94: preserve unsaved edits](https://github.com/CoBuilders-xyz/stylus-cm-frontend/pull/94) |
| Backend | [#89: activations, ABI, migrations](https://github.com/CoBuilders-xyz/stylus-cm-backend/pull/89) | [#90: chain-scoped history and alert fixes](https://github.com/CoBuilders-xyz/stylus-cm-backend/pull/90) |
| Contracts | [#25: CMA v2.0.0](https://github.com/CoBuilders-xyz/stylus-cm-contracts/pull/25) | [#22: audit remediation](https://github.com/CoBuilders-xyz/stylus-cm-contracts/pull/22), [#26: published audit](https://github.com/CoBuilders-xyz/stylus-cm-contracts/pull/26), [#27: local deploy guard](https://github.com/CoBuilders-xyz/stylus-cm-contracts/pull/27) |
