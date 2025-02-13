# Arbitrum Cache Manager GUI

## Overview

Our project is a GUI for managing Arbitrum’s Cache Manager, designed to simplify and optimize the caching of contracts, especially for high-demand applications using Stylus.

This interface provides developers with essential tools to inspect, bid, and manage advanced use cases, addressing the complexities of on-chain caching through a streamlined experience.

## Key Features

### Bidding Module

- One-click and automated bidding based on current cache demand.
- Displays minimum bid required.
- Allows developers to set maximum bids for automatic adjustments to maintain cache priority.

### Alerts and Notifications

- Real-time updates via Telegram and Slack.
- Webhooks to support future notification channels.
- Notifies developers whenever a contract’s cache status changes, enabling proactive responses.

### Visualization and Charts

- Real-time dashboard displaying contract positions, bid amounts, and usage metrics.
- Historical bid trends for data-driven decision-making.

## Open-Source and Multi-Chain Support

- Open-source and self-hostable design.
- Orbit Chain developers can deploy their own instances if needed.
- Seamless connection to multiple chains, including Arbitrum and custom Orbit Chains, eliminating the need for separate instances per chain.

## Running the Project Locally

As the tool is open source, developers can easily download the repository and run it locally. Follow the instructions in our mkdocs documentation to set up and deploy your own instance.

For running mkdocs locally:

```
docker compose -f mkdocs/docker-compose.yaml up -d
```

A web server will be running at http://localhost:8005 with all the documentation about this project.
If you prefer, all Markdown (`.md`) files used by MkDocs for rendering are stored in `mkdocs/docs` folder.
