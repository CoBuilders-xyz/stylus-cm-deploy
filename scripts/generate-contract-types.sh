#!/bin/bash

# Contract Type Generation Script
# This script demonstrates how the contract types were generated

set -e

echo "🏗️  Contract Type Generation Workflow"
echo "======================================"

# Step 1: Compile contracts and generate TypeChain types
echo ""
echo "📝 Step 1: Compiling contracts and generating TypeChain types..."
cd submodules/stylus-cm-contracts
npx hardhat compile

# Step 2: Copy ABIs from compiled artifacts to backend
echo ""
echo "📋 Step 2: Copying ABIs from artifacts to backend..."
cd ../../

# Create directories if they don't exist
mkdir -p submodules/stylus-cm-backend/src/common/abis/cacheManager
mkdir -p submodules/stylus-cm-backend/src/common/abis/cacheManagerAutomation
mkdir -p submodules/stylus-cm-backend/src/common/abis/arbWasm
mkdir -p submodules/stylus-cm-backend/src/common/abis/arbWasmCache

# Copy specific contract ABIs (extract ABI from artifact JSON)
echo "Copying CacheManager ABI..."
jq '.abi' submodules/stylus-cm-contracts/build/artifacts/contracts/interfaces/IExternalContracts.sol/ICacheManager.json > submodules/stylus-cm-backend/src/common/abis/cacheManager/cacheManager.json

echo "Copying CacheManagerAutomation ABI..."
jq '.abi' submodules/stylus-cm-contracts/build/artifacts/contracts/core/CacheManagerAutomation.sol/CacheManagerAutomation.json > submodules/stylus-cm-backend/src/common/abis/cacheManagerAutomation/CacheManagerAutomation.json

echo "Copying ArbWasm ABI..."
# Note: ArbWasm might be from external source, so this is just an example
if [ -f "submodules/stylus-cm-contracts/build/artifacts/contracts/interfaces/IExternalContracts.sol/IArbWasm.json" ]; then
    jq '.abi' submodules/stylus-cm-contracts/build/artifacts/contracts/interfaces/IExternalContracts.sol/IArbWasm.json > submodules/stylus-cm-backend/src/common/abis/arbWasm/ArbWasm.json
fi

echo "Copying ArbWasmCache ABI..."
jq '.abi' submodules/stylus-cm-contracts/build/artifacts/contracts/interfaces/IExternalContracts.sol/IArbWasmCache.json > submodules/stylus-cm-backend/src/common/abis/arbWasmCache/arbWasmCache.json

# Step 3: Generate TypeScript types for backend using TypeChain
echo ""
echo "🔧 Step 3: Generating TypeScript types for backend..."
cd submodules/stylus-cm-backend

# Check if TypeChain is available, if not install it temporarily
if ! command -v typechain &> /dev/null; then
    echo "Installing TypeChain temporarily..."
    npm install --no-save typechain @typechain/ethers-v6
fi

# Generate types using TypeChain with command line arguments
# Based on the typechain.config.ts: target: 'ethers-v6', outDir: 'src/common/types/contracts', glob: 'src/common/abis/**/*.json'
npx typechain --target ethers-v6 --out-dir src/common/types/contracts 'src/common/abis/**/*.json'

echo ""
echo "✅ Contract types generation complete!"
echo ""
echo "Generated files:"
echo "- submodules/stylus-cm-backend/src/common/types/contracts/common.ts"
echo "- submodules/stylus-cm-backend/src/common/types/contracts/index.ts"
echo "- submodules/stylus-cm-backend/src/common/types/contracts/[ContractName].ts"
echo "- submodules/stylus-cm-backend/src/common/types/contracts/factories/..."
echo ""
echo "🎯 The generated types provide:"
echo "   - Fully typed contract interfaces"
echo "   - Type-safe method calls"
echo "   - Event filtering with proper types"
echo "   - Factory classes for contract deployment" 