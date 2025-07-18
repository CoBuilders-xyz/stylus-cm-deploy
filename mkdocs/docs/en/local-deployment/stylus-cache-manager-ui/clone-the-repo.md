# Cloning the Repository

Clone with sub-modules in one step:

```bash
git clone --recurse-submodules https://github.com/cobuilders-xyz/stylus-cm-deploy
```

If you already cloned the repository without the `--recurse-submodules` flag you can initialise and pull the sub-modules afterwards with:

```bash
git submodule update --init --recursive
```

# Initialize the submodules

For this you can use the script

```
npm run submodules:init
```

or manually with

```
cd submodules/stylus-cm-backend
npm install
cd ../stylus-cm-frontend
npm install
cd ../stylus-cm-contracts
npm install
cd ../../
```

Now all the submodules have their deps installed, time to configure the envs.
