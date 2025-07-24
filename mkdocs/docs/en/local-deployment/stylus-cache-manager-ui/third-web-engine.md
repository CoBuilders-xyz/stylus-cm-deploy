# **🤖 ThirdWeb Engine Configuration**

> **Set up ThirdWeb Engine for automated transaction execution** - the self-hosted automation service that handles automated bidding for your Stylus contracts.

---

## **🎯 What is ThirdWeb Engine?**

**ThirdWeb Engine** is a self-hosted automation service that:

- **🤖 Executes Transactions:** Places backend triggered automated bids based on configured rules
- **🔒 Secure Execution:** Handles private keys securely in isolated containers
- **📊 Monitoring:** Provides transaction history and status tracking
- **🌐 Multi-Network:** Supports multiple blockchain networks simultaneously

!!! tip "Why Self-Hosted?"

    Self-hosting Engine v2 gives you full control over your automation infrastructure while maintaining security and reliability.

---

## **🔧 Prerequisites**

Before configuring ThirdWeb Engine, ensure you have:

- **Docker & Docker Compose** installed and running
- **ThirdWeb Account** (free registration at [thirdweb.com](https://thirdweb.com))
- **Deployed CMA Contracts** from the previous step
- **Access to a deployment wallet** for configuration

---

## **📋 Setup Overview**

The configuration process involves:

1. **🏗️ Create ThirdWeb Project** - Set up your workspace
2. **🔑 Configure Environment** - Set up local environment variables
3. **🐳 Deploy Engine Services** - Start the self-hosted automation
4. **🔗 Link to ThirdWeb Dashboard** - Connect local instance to web interface
5. **💰 Configure Wallets** - Set up backend wallet for transactions
6. **🌐 Add Custom Networks** - Configure your Arbitrum networks

!!! tip

    You do **not** need to clone any repository for ThirdWeb Engine. The service runs as a Docker container using an official image pulled directly from Docker Hub.

    Additionally, make sure to run **all commands from the root of the stylus-cm-deploy project**, where the `src/docker/` directory and environment files are located.

---

## **🏗️ Step 1: Create ThirdWeb Project**

### **1.1 Login to ThirdWeb**

Visit [thirdweb.com](https://thirdweb.com) and log in using your wallet

### **1.2 Create New Project**

Create a new project for your automation setup:

<figure markdown="span">
  ![Create Project](./assets/engine-create-project.png){ width="600" }
</figure>

<figure markdown="span">
  ![Create Project Submit](./assets/engine-create-project-submit.png){ width="500" }
</figure>

!!! tip "Domain Configuration"

    For testing, you can allow all domains. For production, specify your backend domain and thirdweb domain for enhanced security.

### **1.3 Save Project Keys**

Copy and save your project keys securely - you'll need them for configuration:

<figure markdown="span">
  ![Create Project Keys](./assets/engine-create-project-keys.png){ width="500" }
</figure>

!!! warning "Key Security"

    The wallet you use to log in will become the project admin. Keep your keys secure and never share them publicly.

---

## **🔑 Step 2: Configure Environment**

### **2.1 Copy Environment Files**

Copy the example environment files:

```bash
cp src/docker/.env.engine.example src/docker/.env.engine
cp src/docker/.env.engine-db.example src/docker/.env.engine-db
```

### **2.2 Configure Engine Environment**

Edit `src/docker/.env.engine` with your ThirdWeb configuration:

```bash
# Required: Complex password for database encryption
ENCRYPTION_PASSWORD=your_complex_encryption_password_here

# Required: Your ThirdWeb API secret key
THIRDWEB_API_SECRET_KEY=your_thirdweb_api_secret_key

# Required: Admin wallet address (use your ThirdWeb login wallet)
ADMIN_WALLET_ADDRESS=0xYourThirdWebLoginWalletAddress

# Required: Backend wallet address (can be same as admin for testing)
BACKEND_WALLET_ADDRESS=0xYourThirdWebLoginWalletAddress

# Optional: Keep defaults for local deployment
POSTGRES_CONNECTION_URL=postgresql://scm-engine-db-user:scm-engine-db-pwd@scm-engine-db:5432/scm_engine_db?sslmode=disable
REDIS_URL=redis://scm-engine-redis:6381?family=0
PORT=3005
HOST=::
```

### **2.3 Configure Database Environment**

Edit `src/docker/.env.engine-db` (keep defaults for local deployment):

```bash
POSTGRES_CONNECTION_URL=postgresql://scm-engine-db-user:scm-engine-db-pwd@scm-engine-db:5432/scm_engine_db?sslmode=disable
REDIS_URL=redis://scm-engine-redis:6381?family=0
PORT=3005
```

---

## **🐳 Step 3: Deploy Engine Services**

### **3.1 Start Engine Services**

Use the automated script to start all Engine services:

```bash
npm run engine:start
```

Or manually start with Docker Compose:

```bash
docker compose -f src/docker/docker-compose.yaml up -d scm-engine-db scm-engine-redis scm-engine
```

### **3.2 Verify Services**

Check that all services are running:

```bash
docker compose -f src/docker/docker-compose.yaml ps
```

You should see:

- `scm-engine-db` - PostgreSQL database
- `scm-engine-redis` - Redis cache
- `scm-engine` - ThirdWeb Engine service

### **3.3 Service Management**

Additional commands for managing Engine services:

```bash
# Pause services
npm run engine:pause

# Stop and remove services
npm run engine:delete

# View logs
docker compose -f src/docker/docker-compose.yaml logs -f scm-engine
```

---

## **🔗 Step 4: Link to ThirdWeb Dashboard**

### **4.1 Allow HTTP Requests**

!!! tip "HTTP Access Required"

    To allow the ThirdWeb frontend to communicate with your local Engine instance, visit this URL in your browser:

    ```
    http://localhost:3005/json
    ```

    Accept the HTTP security warning and allow insecure navigation.

### **4.2 Access Project Transactions**

Navigate to your project's transactions page:

```
https://thirdweb.com/team/<USERNAME>/<PROJECT_NAME>/transactions
```

### **4.3 View Dedicated Engine**

Click on "View Dedicated Engine" to access Engine management:

<figure markdown="span">
  ![Create Project View Dedicated](./assets/engine-dedicated-view.png){ width="500" }
</figure>

### **4.4 Import Local Engine**

Click "Import Engine" to connect your local instance:

<figure markdown="span">
  ![Create Project Import Engine](./assets/engine-dedicated-import.png){ width="500" }
</figure>

### **4.5 Configure Engine Settings**

Configure your local Engine instance:

<figure markdown="span">
  ![Create Project Config Engine](./assets/engine-dedicated-config.png){ width="500" }
</figure>

!!! info "Local Access Only"

    Only you can manage this instance since it's running on localhost. For team access, deploy to cloud or create a tunnel.

### **4.6 Verify Instance**

After importing, you should see your Engine instance in your list.

---

## **💰 Step 5: Configure Backend Wallet**

### **5.1 Import Backend Wallet**

For testing, you can import the admin wallet as the backend wallet:

<figure markdown="span">
  ![Create Project Engine Success](./assets/engine-dedicated-success.png){ width="500" }
</figure>

<figure markdown="span">
  ![Create Project BE Wallet Import](./assets/engine-be-wallet.png){ width="500" }
</figure>

!!! warning "Production Security"

    For production, use a separate wallet for backend operations. Backend wallets only need balance - if compromised, you can replace them easily.

### **5.2 Verify Wallet Import**

Confirm the wallet is successfully imported:

<figure markdown="span">
  ![Create Project  BE Wallet Success](./assets/engine-be-wallet-success.png){ width="500" }
</figure>

---

## **🔑 Step 6: Create Access Token**

### **6.1 Generate Access Token**

Go to the Access Tokens section and create a new token:

<figure markdown="span">
  ![Create Project Access Token](./assets/engine-access-token.png){ width="500" }
</figure>

### **6.2 Save Token**

Copy and save your access token securely:

<figure markdown="span">
  ![Create Project Access Token Success](./assets/engine-access-token-success.png){ width="500" }
</figure>

!!! warning "Token Security"

    Keep this token secure - it's required for backend communication with Engine.

---

## **🌐 Step 7: Add Custom Networks**

### **7.1 Add Local Testnode**

Use your access token to add your local Arbitrum testnode:

```bash
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

!!! tip "Docker Networking"

    We use `host.docker.internal:8547` instead of `localhost:8547` because Engine runs in Docker containers and needs to access the host machine's localhost.

### **7.2 Add Other Networks**

You can add any custom network to Engine by using the same request we used for adding Arbitrum Local Testnode

## **✅ Configuration Complete**

Congratulations! Your ThirdWeb Engine is now configured and ready to:

- **🤖 Execute automated transactions** for cache bidding
- **📊 Monitor transaction status** through the ThirdWeb dashboard
- **🔒 Securely manage private keys** in isolated containers
- **🌐 Support multiple networks** for different environments

---

## **🔧 Next Steps**

With Engine configured, proceed to **[SCM UI Backend](scm-ui-backend.md)** - Configure the backend API service

---
