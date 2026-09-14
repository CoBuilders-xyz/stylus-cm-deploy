# Preview and verify the documentation

From the repository root, using Python with MkDocs Material installed:

```bash
mkdocs serve -f mkdocs/mkdocs.yml -a 127.0.0.1:8005
```

Open <http://localhost:8005>. Alternatively, with Docker running:

```bash
docker compose -f mkdocs/docker-compose.yaml up -d
```

Before submitting documentation changes, build with strict validation:

```bash
mkdocs build --strict -f mkdocs/mkdocs.yml
```

The September 2026 update was checked with MkDocs 1.6.1 and Material 9.7.6. Generated output goes to the ignored `mkdocs/site/` directory by default.

Keep the English, task-oriented guides, numbered workflows, figures, and existing public page URLs. Use the product name **Stylus Manager** while preserving protocol and repository identifiers such as `CacheManager`, `CacheManagerAutomation`, and `stylus-cm-*`.

## Screenshots

- `docs/en/tutorials/assets/` contains recorded activation and caching lifecycle screenshots from a disposable local devnode. Reuse them when they illustrate the same action; do not present their balances, timestamps, addresses, or expiry periods as current public-network values.
- Older wallet connection/signature and Gas Tank withdrawal images are retained under `docs/en/getting-started/stylus-cache-manager-ui/tutorials/assets/`. Their captions explain the earlier visual style.
- `manager-dashboard-v2.png` and `manager-commands-v2.png` in that directory were captured from the public app on September 11, 2026, on Arbitrum Sepolia, without a wallet session. The app was inspected through Orca; the final public-page PNGs were captured in a separate headless Chrome session because the embedded browser capture repeated viewport tiles.
- Preserve actual UI text in screenshots. Explain outdated wording in the guide when necessary; for example, the retained “pending audit” acknowledgement is contextualized by the published v2 contract audit.
- Verify each new image visually and check its rendered page on desktop and mobile. Use meaningful alt text and avoid exposing private wallet data or live notification credentials.

The historical `docs/en/old/` tree remains available at its existing paths. The current navigation describes v2.

## Naming conventions

Use **Stylus Manager** for the product, **auto-activation** for automatic reactivation, and **cache bid automation** for automatic cache bids. Use **Stylus Manager automation contracts** in deployment titles and general descriptions; introduce the actual `CacheManagerAutomation` (CMA) and `BiddingEscrow` identifiers where readers interact with them.

**CacheManager** refers specifically to Arbitrum's cache auction contract. Do not rename protocol contracts, ABI fields, commands, environment variables, repository paths, or screenshot text to match the product branding. The former product name belongs only in explicit rename history. Archived pages must identify their historical status and link to current guidance.
