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

!!! Note

    Cached bytecode is be unique, if several addresses share the bytecode, its cached only once.  If you want to cache several bytecodes for testing we suggest modifiying a little bit the sourcecode of the contract.

     Modify `src/lib.rs` before deployment, e.g., add a function:
    ```rust
    /// Sets a number in storage to a user-specified value.
    pub fn set_number_version_1(&mut self, new_number: U256) {
        self.number.set(new_number);
    }
    ```

---

### Place a bid using cargo-cli

Have troubles installing stylus? check [Arbitrum docs](https://docs.arbitrum.io/stylus/using-cli)
