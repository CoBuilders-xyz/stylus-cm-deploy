# **API Reference**

The Stylus Manager backend exposes **Swagger UI** at `/api` and the raw OpenAPI document at `/api-json`. Use the schema served by the backend version you are integrating with.

| Environment | Swagger UI |
| --- | --- |
| Local backend | [http://localhost:3000/api](http://localhost:3000/api) |
| Staging proxy | [Staging API](https://stylus-nginx-staging.up.railway.app/api#/) |
| Self-hosted / production | Append `/api` to the configured backend URL. Reverse-proxy access rules also apply. |

## **Wallet authentication**

1. Call `GET /auth/generate-nonce/:address` with the wallet's EIP-55 checksum address.
2. Sign the returned `nonce` message with that wallet.
3. Send `POST /auth/login` with `address` and `signature`.
4. Use the returned `accessToken` as a Bearer token, or paste it into Swagger's **Authorize** dialog.

The nonce is consumed after successful login. Generate a new one for the next authentication attempt. The signed message may still use the former product name in this backend release.

## **Activation and caching data**

| Route | Purpose |
| --- | --- |
| `GET /blockchains` | Enabled networks and their contract addresses, including `cacheManagerAutomationAddress`. |
| `GET /contracts` | Indexed contracts, cache information, and activation readings. |
| `GET /contracts/:id` | Contract details, including bid and CMA activation histories. |
| `GET /user-contracts` | The authenticated user's saved contracts. |
| `GET /user-contracts/:id` | Saved contract details for the authenticated user. |
| `GET /contracts/suggest-bids/by-address/:address` | Suggested cache bids for a program; supply the blockchain identifier required by Swagger. |
| `GET /contracts/suggest-bids/by-size/:size` | Suggested bids for a program size. |

Use the blockchain's API identifier where an endpoint expects `blockchainId`; it is not interchangeable with the numeric EVM chain ID. Consult Swagger for filters, pagination, sorting, and authentication requirements.

### **Activation fields**

List and detail responses expose `programTimeLeft` as seconds encoded in a string, or `null`, plus `programTimeLeftReason` (`never_activated`, `expired`, `needs_upgrade`, or `null`). An unavailable read is not equivalent to zero remaining lifetime.

Persisted fields include `activationStatus`, `lastActivationTimestamp`, `activationRetryCount`, `autoActivate`, and `maxActivationCost`. Cache bidding uses the separate `biddingEnabled` field.

The detail `activationHistory` contains CMA `ActivationPerformed` and `ActivationError` events scoped to the chain and contract address. It is not a complete index of direct wallet calls to ArbWasm.

Saving a watchlist contract or setting alerts through the API does not execute an on-chain activation, cache bid, deposit, or automation configuration transaction. Those actions use the wallet or the operator's CMA worker.

## **Quick authentication for local development**

In `local`, `develop`, and `staging`, the backend also provides `POST /auth/test-login`. Use only a disposable key with a development backend you control:

```bash
curl -X POST http://localhost:3000/auth/test-login \
  -H "Content-Type: application/json" \
  -d '{
    "address": "0xYOUR_CHECKSUM_TEST_WALLET_ADDRESS",
    "pk": "0xYOUR_DISPOSABLE_TEST_PRIVATE_KEY"
  }'
```

Replace the placeholders before running. Both `test-login` and `sign-message` are disabled in production; normal wallet-signature login is the production flow.

See [Activation Lifecycle](deep-dive/activation-lifecycle.md) for state interpretation and [v2 release notes](releases/stylus-manager-v2.md) for migration and ABI compatibility.
