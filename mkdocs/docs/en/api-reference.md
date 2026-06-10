# API Reference

The Stylus Manager backend exposes an interactive **Swagger UI** at the `/api` path of any running instance.

## Environments

| Environment | Swagger UI |
|------------|------------|
| **Local** | [http://localhost:3000/api](http://localhost:3000/api) |
| **Staging** | [stylus-nginx-staging.up.railway.app/api](https://stylus-nginx-staging.up.railway.app/api#/) |
| **Production** | TBD |

The raw OpenAPI spec (JSON) is available at `/api-json`.

## Quick Authentication (dev only)

In local/develop/staging environments, use the **test-login** endpoint to get a JWT token in one step:

```bash
curl -X POST https://stylus-nginx-staging.up.railway.app/auth/test-login \
  -H "Content-Type: application/json" \
  -d '{
    "address": "0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E",
    "pk": "0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659"
  }'
```

Then use the returned `accessToken` in the **Authorize** button of Swagger UI (Bearer token).

!!! warning
    The `test-login` endpoint is disabled in production.
