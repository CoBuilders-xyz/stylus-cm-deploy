# Stylus Cache Manager UI: Overview

The Stylus Cache Manager UI is a web application that makes it easy to manage, monitor, and automate cache slots for your Stylus contracts on Arbitrum. It brings together wallet-based authentication, contract management, bidding, automation, alerts, and analytics—all in one place.

---

## Key Features

### 1. Wallet Login (Sign Message)

Authenticate securely using your Ethereum wallet. The backend verifies your identity via a signed message—no passwords required.

- **Repo:** `stylus-cm-backend`

### 2. My Contracts: Personal Contract Storage

Save and organize your contracts in the “My Contracts” section. The backend stores your contract list and preferences, so you can quickly access and manage your deployments.

- **Repo:** `stylus-cm-backend`

### 3. Manual Bidding

Place bids for cache slots directly from the dApp. The UI guides you through the process and interacts with the Cache Manager contract on-chain.

- **Repo:** `stylus-cm-frontend`

### 4. Automated Bidding

Let the system maintain your cache slot automatically. The backend and smart contracts work together to monitor your position and place bids as needed, reducing the risk of eviction.

- **Repos:** `stylus-cm-backend`, `stylus-cm-contracts`

### 5. Alert System

Get notified when your cache slot is at risk, your bid is low, or other important events occur. Alerts can be sent via Telegram, Slack, webhooks, or email.

- **Repo:** `stylus-cm-backend`

### 6. Metrics & Analytics

Track cache usage, bid trends, and contract status in real time. The backend processes blockchain data and provides actionable insights through the UI.

- **Repo:** `stylus-cm-backend`

---

## How it works

- **Frontend:** Built with Next.js, React, and RainbowKit for wallet integration. Connects to the backend via REST APIs.
- **Backend:** Handles authentication, contract storage, bidding logic, alerting, and analytics.
- **Smart Contracts:** Automate cache management and secure bidding on-chain.

---

## Want to know more?

If you need a detailed flow or want to see how a specific feature works, let me know which one and I’ll dig into the code or ask for your input.
