## **🚀 Install Cargo CLI**

### **1️⃣ Install Rust & Stylus CLI**

Install [Rust](https://www.rust-lang.org/tools/install) and then install the Stylus CLI tool:

```bash
cargo install --force cargo-stylus cargo-stylus-check
```

### **2️⃣ Add Wasm Target**

```bash
rustup target add wasm32-unknown-unknown
```

### **3️⃣ Initialize & Deploy a Contract**

```bash
RPC=http://localhost:8547
ARB_PREFUNDED_PK=0xb6b15c8cb491557369f3c7d2c287b053eb229daa9c22138887752191c9520659
cargo stylus new counterTest --minimal
cd counterTest
cargo stylus check --endpoint $RPC
cargo stylus deploy --endpoint $RPC --private-key $ARB_PREFUNDED_PK --no-verify
```

!!! note "Cached Bytecode Uniqueness"

    Cached bytecode is unique - if several addresses share the same bytecode, it's cached only once. If you want to cache several bytecodes for testing, we suggest modifying the source code slightly.

        Modify `src/lib.rs` before deployment, e.g., add a function:
        ```rust
        /// Sets a number in storage to a user-specified value.
        pub fn set_number_version_1(&mut self, new_number: U256) {
            self.number.set(new_number);
        }
        ```

---

## **💰 Place a Bid using Cargo CLI**

### **Basic Bid Placement**

```bash
# Replace SC_ADD with your contract address
export SC_ADD=
cargo stylus cache bid $SC_ADD 0 --private-key $ARB_PREFUNDED_PK --endpoint $RPC
```

### **Cache Your Contract**

After deploying your contract, you can cache it with:

```bash
# Cache your activated contract in ArbOS
cargo stylus cache bid $SC_ADD 0 --private-key $ARB_PREFUNDED_PK --endpoint $RPC
```

### **Additional Cache Commands**

```bash
# Check cache status
cargo stylus cache status --endpoint $RPC

# Check specific contract cache status
cargo stylus cache status --endpoint $RPC --address $SC_ADD

# Get bid suggestions
cargo stylus cache suggest-bid $SC_ADD --endpoint $RPC
```

---

## **📚 Further Reading**

For more information about the Stylus contract cache system:

- **Stylus Cache Manager Documentation**: [https://docs.arbitrum.io/stylus/concepts/stylus-cache-manager](https://docs.arbitrum.io/stylus/concepts/stylus-cache-manager)
- **Arbitrum Stylus Documentation**: [https://docs.arbitrum.io/stylus/](https://docs.arbitrum.io/stylus/)

---

!!! question "Having troubles installing Stylus?"

    Check the [Arbitrum Stylus CLI documentation](https://docs.arbitrum.io/stylus/using-cli) for detailed installation instructions and troubleshooting.
