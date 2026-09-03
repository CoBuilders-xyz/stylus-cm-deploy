import "dotenv/config";
import hardhatEthers from "@nomicfoundation/hardhat-ethers";
import { defineConfig } from "hardhat/config";

const privateKey = process.env.PRIVATE_KEY;

export default defineConfig({
  plugins: [hardhatEthers],
  networks: {
    arbitrumSepolia: {
      type: "http",
      chainType: "generic",
      chainId: 421614,
      url:
        process.env.ARB_SEPOLIA_RPC_URL ??
        "https://sepolia-rollup.arbitrum.io/rpc",
      accounts: privateKey ? [privateKey] : [],
    },
  },
});
