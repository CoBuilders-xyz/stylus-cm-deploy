Third web engine is essencial for Automations feature to work.

To avoid having to handle automations in our backend directly we are using third web solution "Engine"
The self hosted option is allowed for Engine v2

https://portal.thirdweb.com/engine/v2

The service is already present in docker compose for deployment but we have to create a third web account for getting configuration parameters

You can login here

https://thirdweb.com/

In this case we will log in using a wallet

<figure markdown="span">
  ![Create Project](./assets/engine-create-project.png){ width="600" }
</figure>

Once logged in, we will create a project. We will allow all domains for testing purposes but you can set your backend domain and thirdweb domain (for management from third web page)

<figure markdown="span">
  ![Create Project Submit](./assets/engine-create-project-submit.png){ width="500" }
</figure>

Note: Domains can be updated later if needed

Copy your keys somewhere safe, we will use them later for setting up the engine env variables

<figure markdown="span">
  ![Create Project Keys](./assets/engine-create-project-keys.png){ width="500" }
</figure>

The Wallet we logged in with will be the project admin.

It's time to set engine environment variables up

```
cp src/docker/.env.engine.example src/docker/.env.engine
cp src/docker/.env.engine-db.example src/docker/.env.engine-db
```

Engine envs
ENCRYPTION_PASSWORD= ANYTHING_COMPLEX_TO_ENCRYPT_DB_DATA

THIRDWEB_API_SECRET_KEY= COMPLETE_WITH_THIRD_WEB_API_SECRET

ADMIN_WALLET_ADDRESS= WILL_USE_THIRD_WEB_LOGIN_WALLET (If you use social login, you will have an address set, use that one)

BACKEND_WALLET_ADDRESS= WILL_USE_THIRD_WEB_LOGIN_WALLET

We can Keep the rest as default for local deploy.

POSTGRES_CONNECTION_URL=postgresql://scm-engine-db-user:scm-engine-db-pwd@scm-engine-db:5432/scm_engine_db?sslmode=disable
REDIS_URL=redis://scm-engine-redis:6381?family=0
PORT=3005
HOST=::

Engine DB Envs

We can Keep the rest as default for local deploy.

POSTGRES_CONNECTION_URL=postgresql://scm-engine-db-user:scm-engine-db-pwd@scm-engine-db:5432/scm_engine_db?sslmode=disable
REDIS_URL=redis://scm-engine-redis:6381?family=0
PORT=3005
HOST=::

We are ready to start up engine service and connect thirdweb online panel with our local instance for management

```
npm run engine:start
```

or manually

```
docker compose -f src/docker/docker-compose.yaml up -d scm-engine-db scm-engine-redis scm-engine
```

you can also pause and delete engine services with

```
npm run engine:pause
npm run engine:delete
```

Once engine is up and running, we need to add our engine instance to thirdweb frontend for management.

!!! Tip Allow HTTP requests

    A little hack so that the frontend can communicate though http with our local instance is to access this url from the browser you will be using for third web management.

    ```
    http://localhost:3005/json
    ```
    Accept the typical HTTP warning and allow insecure navigation.

Once done, lets go to thirdweb panel and link our local instance with our account for proper management.

Go to your project transactions and click on "View Dedicated Engine"

```
https://thirdweb.com/team/<USERNAME>/<PROJECT_NAME>/transactions
```

<figure markdown="span">
  ![Create Project View Dedicated](./assets/engine-dedicated-view.png){ width="500" }
</figure>

And click "Import Engine" for importing your local instance

<figure markdown="span">
  ![Create Project Import Engine](./assets/engine-dedicated-import.png){ width="500" }
</figure>

Finally configure this settings.

<figure markdown="span">
  ![Create Project Config Engine](./assets/engine-dedicated-config.png){ width="500" }
</figure>

Note: Only you will be able to manage this instance because thirdweb frontend will try to access a localhost service.
If you want your team to have access to the instance you should deploy the solution cloud or create a tunnel for outside access.

After importing the engine, click your instance and you should see something like this

<figure markdown="span">
  ![Create Project Engine Success](./assets/engine-dedicated-success.png){ width="500" }
</figure>

Only three more steps left.
Create our backend wallet, in charge of placing the transactions triggered by automation service
Create an access token so that the backend can connect to engine service
Create a custom network in your engine so that the engine can execute transactions in you arbitrum local testnode.

For this test we will import the admin wallet as our backend wallet, but we strongly suggest to use different wallets. Backend wallets are not that importan, only should hold balance, if they get compromised, you can just import or create a new one and fund it.

<figure markdown="span">
  ![Create Project BE Wallet Import](./assets/engine-be-wallet.png){ width="500" }
</figure>

<figure markdown="span">
  ![Create Project  BE Wallet Success](./assets/engine-be-wallet-success.png){ width="500" }
</figure>

Wallet done, lets create an access token

Go to access tokens section and create a new one

<figure markdown="span">
  ![Create Project Access Token](./assets/engine-access-token.png){ width="500" }
</figure>
<figure markdown="span">
  ![Create Project Access Token Success](./assets/engine-access-token-success.png){ width="500" }
</figure>

Keep the token somwhere safe

Now we have the token we can interact with engine API and add our localhost testnode with

```
ACCESS_TOKEN=<PASTE_YOUR_ACCESS_TOKEN>
curl --location 'http://localhost:3005/configuration/chains' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer '$ACCESS_TOKEN \
--data '{
  "chainOverrides": [
    {
      "name": "Arbitrum Local",
      "chain": "ETH",
      "rpc": [
        "http://host.docker.internal:8547"
      ],
      "nativeCurrency": {
        "name": "Ether",
        "symbol": "ETH",
        "decimals": 18
      },
      "chainId": 412346,
      "slug": "arbitrum-local"
    }
  ]
}'
```

We are using host.docker.internal instead of localhost:8547 because from engine's service perspective, localhost lives in engine containers scope and we need the engine to be able to talk with arbitrum local rpc.

We have successfully configured engine service. Keep the access token because we will need it for stylus backend setup.
