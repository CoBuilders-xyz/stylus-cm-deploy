import { network } from "hardhat";

const { ethers } = await network.create();

const ARB_WASM = "0x0000000000000000000000000000000000000071";

const ARB_WASM_ABI = [
  "function programTimeLeft(address program) view returns (uint64)",
  "function activateProgram(address program) payable returns (uint16 version, uint256 dataFee)",
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
    throw new Error("PRIVATE_KEY is required to activate a program");
  }
  if ((await ethers.provider.getCode(program)) === "0x") {
    throw new Error(`No contract bytecode found at ${program}`);
  }

  const arbWasm = new ethers.Contract(ARB_WASM, ARB_WASM_ABI, signer);
  try {
    const secondsLeft = (await arbWasm.programTimeLeft(program)) as bigint;
    if (secondsLeft > 0n) {
      console.log(`Already active with ${secondsLeft} seconds remaining.`);
      return;
    }
  } catch {
    // NotActivated, Expired, and NeedsUpgrade are all states in which an
    // activation attempt is useful. The simulation below remains authoritative.
  }

  const ceilingEth = process.env.ACTIVATION_FEE_CEILING_ETH || "0.01";
  const ceiling = ethers.parseEther(ceilingEth);
  console.log(`Program:       ${program}`);
  console.log(`Fee ceiling:   ${ceiling} wei (${ceilingEth} ETH)`);

  let version: bigint;
  let dataFee: bigint;
  try {
    [version, dataFee] = (await arbWasm.activateProgram.staticCall(program, {
      value: ceiling,
    })) as [bigint, bigint];
  } catch (error) {
    throw new Error(
      "Activation simulation failed. Confirm the program state and raise " +
        "ACTIVATION_FEE_CEILING_ETH if the ceiling is too low.",
      { cause: error },
    );
  }

  console.log(`Stylus version: ${version}`);
  console.log(`Quoted data fee: ${dataFee} wei`);
  const transaction = await arbWasm.activateProgram(program, { value: dataFee });
  console.log(`Transaction:    ${transaction.hash}`);
  await transaction.wait();

  const secondsLeft = (await arbWasm.programTimeLeft(program)) as bigint;
  console.log(`Active:         true`);
  console.log(`Time remaining: ${secondsLeft} seconds`);
}

main().catch((error: unknown) => {
  console.error(error);
  process.exitCode = 1;
});
