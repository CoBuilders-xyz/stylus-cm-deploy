For this example we will deploy cma contracts in local testnode and sepolia
The script is prepared for deploying to arbitrum One, arbitrum Sepolia and arbitrum local testnode.
If you want to add another arbitrum-like chain that supports cache manager you may want to take a look at
submodules/stylus-cm-contracts/config/deployment-config.ts
and submodules/stylus-cm-contracts/config/constants.ts

Go to smart contracts submodule

```
 cd submodules/stylus-cm-contracts
```

Copy env.example into env and fill sepolia data if you want to configure sepolia as well, otherwise can use only local testnode for testing

Once configured we can run the following commands

Local Deploy

```
npm run deploy:local
```

or directly

```
npx hardhat run scripts/deploy/deploy-cache-manager-automation.ts --network localArb"
```

you should get something like

```
📊 Deployment Summary:
{
  "network": "localArb",
  "cacheManagerAutomation": "0xA6E41fFD769491a42A6e5Ce453259b93983a22EF",
  "deployer": "0x3f1Eae7D46d88F08fc2F8ed27FCb2AB183EB2d0E",
  "timestamp": "2025-07-17T23:04:10.642Z"
}
```

Sepolia Deploy

```
npm run deploy:sepolia
```

or directly

```
npx hardhat run scripts/deploy/deploy-cache-manager-automation.ts --network arbitrumSepolia",
```

you should get something like

```
📊 Deployment Summary:
{
  "network": "arbitrumSepolia",
  "cacheManagerAutomation": "0x1B38ABF292a39F659916A9e7074aB1C3407196A9",
  "deployer": "0x39DaE6A77A5165598aEB84cAe96Aea0A2215bCa8",
  "timestamp": "2025-07-17T23:04:54.430Z"
}
```

Congratulations your Cache Manager Automation contracts are deployed!

Go back to root folder for the next section

```
cd ../..
```
