## Check if node version is greater than or equal to 22 and npm version is greater than 10.9

# Check Node.js version
node_version=$(node -v | sed 's/v//')
major_version=$(echo "$node_version" | cut -d. -f1)

if [ "$major_version" -lt 22 ]; then
  echo "Node version must be greater than or equal to 22. Current version: v$node_version"
  exit 1
fi

# Check npm version
npm_version=$(npm -v)
npm_major=$(echo "$npm_version" | cut -d. -f1)
npm_minor=$(echo "$npm_version" | cut -d. -f2)

if [ "$npm_major" -lt 10 ] || ([ "$npm_major" -eq 10 ] && [ "$npm_minor" -lt 9 ]); then
  echo "npm version must be greater than 10.9. Current version: $npm_version"
  exit 1
fi

echo "Version check passed: Node.js v$node_version, npm $npm_version"

# Install dependencies for stylus-cm-backend
echo "Installing dependencies for stylus-cm-backend"
cd submodules/stylus-cm-backend
npm install 

# Install dependencies for stylus-cm-frontend
echo "Installing dependencies for stylus-cm-frontend"
cd ../stylus-cm-frontend
npm install 

# Install dependencies for stylus-cm-ui
echo "Installing dependencies for stylus-cm-contracts"
cd ../stylus-cm-contracts
npm install 

cd ../../