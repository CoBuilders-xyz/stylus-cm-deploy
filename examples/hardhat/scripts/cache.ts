import { network } from "hardhat";

const { ethers } = await network.create();

const ARB_WASM_CACHE = "0x0000000000000000000000000000000000000072";

const ARB_WASM_CACHE_ABI = [
  "function allCacheManagers() view returns (address[] managers)",
  "function codehashIsCached(bytes32 codehash) view returns (bool)",
] as const;

// Only the functions used by this example are included. getMinBid is overloaded
// in the full ABI, so using this minimal ABI also keeps the call unambiguous.
const CACHE_MANAGER_ABI = [
  "function getMinBid(address program) view returns (uint192)",
  "function placeBid(address program) payable",
] as const;

function requiredAddress(name: string): string {
  const value = process.env[name];
  if (!value || !ethers.isAddress(value)) {
    throw new Error(`${name} must be a valid address in .env`);
  }
  return ethers.getAddress(value);
}

async function main(): Promise<void> {
  const network = await ethers.provider.getNetwork();
  if (network.chainId !== 421614n) {
    throw new Error(`Expected Arbitrum Sepolia (421614), got ${network.chainId}`);
  }

  const program = requiredAddress("STYLUS_CONTRACT_ADDRESS");
  const [signer] = await ethers.getSigners();
  if (!signer) {
    throw new Error("PRIVATE_KEY is required to place a cache bid");
  }

  const bytecode = await ethers.provider.getCode(program);
  if (bytecode === "0x") {
    throw new Error(`No contract bytecode found at ${program}`);
  }
  const codehash = ethers.keccak256(bytecode);

  const arbWasmCache = new ethers.Contract(
    ARB_WASM_CACHE,
    ARB_WASM_CACHE_ABI,
    signer,
  );
  if (await arbWasmCache.codehashIsCached(codehash)) {
    console.log(`Already cached: ${program}`);
    return;
  }

  // Chains can replace their CacheManager. The last registered manager is the
  // current one, which is also how cargo-stylus discovers it.
  const managers = (await arbWasmCache.allCacheManagers()) as string[];
  if (managers.length === 0) {
    throw new Error("ArbWasmCache returned no registered CacheManager");
  }
  const managerAddress = ethers.getAddress(managers[managers.length - 1]);
  const cacheManager = new ethers.Contract(
    managerAddress,
    CACHE_MANAGER_ABI,
    signer,
  );

  const minimumBid = (await cacheManager.getMinBid(program)) as bigint;
  const configuredBid = process.env.CACHE_BID_WEI?.trim();
  const bid = configuredBid ? BigInt(configuredBid) : minimumBid;
  if (bid < minimumBid) {
    throw new Error(
      `CACHE_BID_WEI (${bid}) is below the current minimum (${minimumBid})`,
    );
  }

  console.log(`Program:       ${program}`);
  console.log(`Codehash:      ${codehash}`);
  console.log(`CacheManager:  ${managerAddress}`);
  console.log(`Minimum bid:   ${minimumBid} wei`);
  console.log(`Submitting:    ${bid} wei`);

  const transaction = await cacheManager.placeBid(program, { value: bid });
  console.log(`Transaction:   ${transaction.hash}`);
  await transaction.wait();

  const cached = await arbWasmCache.codehashIsCached(codehash);
  console.log(`Cached:        ${cached}`);
  if (!cached) {
    throw new Error("The transaction confirmed, but the codehash is not cached");
  }
}

main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
