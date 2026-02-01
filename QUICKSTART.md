# Quick Start Guide

## 🚀 Get Started in 5 Minutes

### Step 1: Install Dependencies

```bash
# Install Node.js dependencies
npm install

# Install Rust (if not installed)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source $HOME/.cargo/env

# Install Soroban CLI
cargo install --locked soroban-cli
```

### Step 2: Configure Environment

```bash
# Copy environment template
cp env.example .env.local

# Edit .env.local and add your secret keys:
# - ISSUER_SECRET_KEY (from your issuer account)
# - DISTRIBUTOR_SECRET_KEY (from your distributor account)
```

**Get Testnet XLM**:
- Visit: https://www.stellar.org/laboratory/#account-creator?network=test
- Fund your issuer and distributor accounts

### Step 3: Build Contracts

```bash
cd contracts
soroban contract build
```

**Note**: The Soroban CLI uses the `wasm32v1-none` target. The WASM files will be in `target/wasm32v1-none/release/`.

### Step 4: Deploy Contracts

```bash
# Configure Soroban for testnet
# On Windows PowerShell, use a single line:
soroban network add testnet --rpc-url https://soroban-testnet.stellar.org --network-passphrase "Test SDF Network ; September 2015"

# Or on Linux/Mac with line continuation:
# soroban network add testnet \
#   --rpc-url https://soroban-testnet.stellar.org \
#   --network-passphrase "Test SDF Network ; September 2015"

# Deploy Token Contract
# On Windows PowerShell (from contracts directory):
cd contracts
$TOKEN_CONTRACT_ID = soroban contract deploy --wasm target/wasm32v1-none/release/inr_token.wasm --source-account SCRUHBUQEEBXE2K7M7VJJDAP5RHEWIOAVOQSRRWFQTS5EAMLU4HPPADQ --network testnet
Write-Host "Token Contract ID: $TOKEN_CONTRACT_ID"
# Add this to .env.local as TOKEN_CONTRACT_ID

# On Linux/Mac (bash):
# cd contracts
# TOKEN_CONTRACT_ID=$(soroban contract deploy --wasm target/wasm32v1-none/release/inr_token.wasm --source-account $ISSUER_SECRET_KEY --network testnet)
# echo "Token Contract ID: $TOKEN_CONTRACT_ID"

# Deploy Remittance Contract
# On Windows PowerShell (from contracts directory):
$REMITTANCE_CONTRACT_ID = soroban contract deploy --wasm target/wasm32v1-none/release/remittance.wasm --source-account SCRUHBUQEEBXE2K7M7VJJDAP5RHEWIOAVOQSRRWFQTS5EAMLU4HPPADQ --network testnet
Write-Host "Remittance Contract ID: $REMITTANCE_CONTRACT_ID"
# Add this to .env.local as REMITTANCE_CONTRACT_ID

# On Linux/Mac (bash):
# REMITTANCE_CONTRACT_ID=$(soroban contract deploy --wasm target/wasm32v1-none/release/remittance.wasm --source-account $ISSUER_SECRET_KEY --network testnet)
# echo "Remittance Contract ID: $REMITTANCE_CONTRACT_ID"
```

### Step 5: Initialize Contracts

**IMPORTANT**: Replace `CBEWURGFLHZ5S4HF63DCNA5AAZPEBS5W4MMLV4CQFZ7ELUWM5RIZK2V3` with your actual Token Contract ID  
**IMPORTANT**: Replace `CBHNRABJQEO4ONOI26ZB7UNT3S2FQRFHXX2VB56UPQJTANX2MVECFED4` with your actual Remittance Contract ID

```powershell
# On Windows PowerShell:
# Initialize Token Contract
soroban contract invoke --id CBEWURGFLHZ5S4HF63DCNA5AAZPEBS5W4MMLV4CQFZ7ELUWM5RIZK2V3 --source-account SCRUHBUQEEBXE2K7M7VJJDAP5RHEWIOAVOQSRRWFQTS5EAMLU4HPPADQ --network testnet -- initialize --issuer GCWCPJZUE3GIPGLYMX6SHDEFRNHGQZSFSYL3G34AOWWAPZTA4GHLKEGG --distributor GA3IGU5LOG2ACMMYZEIM2UO6EOYMQI24GB6SBETT3WN5A45JLYIPSOPI

# Initialize Remittance Contract
soroban contract invoke --id CBHNRABJQEO4ONOI26ZB7UNT3S2FQRFHXX2VB56UPQJTANX2MVECFED4 --source-account SCRUHBUQEEBXE2K7M7VJJDAP5RHEWIOAVOQSRRWFQTS5EAMLU4HPPADQ --network testnet -- initialize --token_contract CBEWURGFLHZ5S4HF63DCNA5AAZPEBS5W4MMLV4CQFZ7ELUWM5RIZK2V3
```

```bash
# On Linux/Mac (bash):
# Initialize Token Contract
soroban contract invoke --id $TOKEN_CONTRACT_ID --source-account $ISSUER_SECRET_KEY --network testnet -- initialize --issuer GCWCPJZUE3GIPGLYMX6SHDEFRNHGQZSFSYL3G34AOWWAPZTA4GHLKEGG --distributor GA3IGU5LOG2ACMMYZEIM2UO6EOYMQI24GB6SBETT3WN5A45JLYIPSOPI

# Initialize Remittance Contract
soroban contract invoke --id $REMITTANCE_CONTRACT_ID --source-account $ISSUER_SECRET_KEY --network testnet -- initialize --token_contract $TOKEN_CONTRACT_ID
```

### Step 6: Mint Test Tokens

```powershell
# On Windows PowerShell:
# Mint 1000 INR tokens to distributor (1000000000 = 1000 with 6 decimals)
# Note: --caller must be the issuer public key
soroban contract invoke --id CBEWURGFLHZ5S4HF63DCNA5AAZPEBS5W4MMLV4CQFZ7ELUWM5RIZK2V3 --source-account SCRUHBUQEEBXE2K7M7VJJDAP5RHEWIOAVOQSRRWFQTS5EAMLU4HPPADQ --network testnet -- mint --caller GCWCPJZUE3GIPGLYMX6SHDEFRNHGQZSFSYL3G34AOWWAPZTA4GHLKEGG --to GA3IGU5LOG2ACMMYZEIM2UO6EOYMQI24GB6SBETT3WN5A45JLYIPSOPI --amount 1000000000
```

```bash
# On Linux/Mac (bash):
# Mint 1000 INR tokens to distributor
soroban contract invoke --id $TOKEN_CONTRACT_ID --source-account $ISSUER_SECRET_KEY --network testnet -- mint --to GA3IGU5LOG2ACMMYZEIM2UO6EOYMQI24GB6SBETT3WN5A45JLYIPSOPI --amount 1000000000
```

### Step 7: Run Frontend

```bash
# From project root
npm run dev
```

Visit `http://localhost:5173` (or the port shown)

### Step 8: Test Remittance

1. Connect your wallet (Freighter extension)
2. Request tokens from distributor (via backend API)
3. Send remittance to a recipient address
4. Check transaction on [Stellar Explorer](https://stellar.expert/explorer/testnet)

---

## 📋 Checklist

- [ ] Rust and Soroban CLI installed
- [ ] Node.js dependencies installed
- [ ] `.env.local` configured with secret keys
- [ ] Issuer and distributor accounts funded with XLM
- [ ] Contracts built successfully
- [ ] Contracts deployed to testnet
- [ ] Contracts initialized
- [ ] Test tokens minted
- [ ] Frontend running
- [ ] Wallet connected
- [ ] Test remittance completed

---

## 🐛 Common Issues

### "Insufficient balance for fees"
- Fund your accounts with testnet XLM from the account creator

### "Contract not initialized"
- Make sure you've called `initialize` on both contracts

### "Only issuer can mint"
- Verify you're using the issuer secret key, not distributor

### Frontend can't connect
- Check that `VITE_BACKEND_API_URL` is set correctly
- Ensure backend is running (if using separate backend server)

---

## 📚 Next Steps

- Read the full documentation: `STELLAR_REMITTANCE_README.md`
- Explore the contract code: `contracts/`
- Check backend services: `backend/stellar/`
- Review frontend config: `src/config/stellar.ts`

---

**Happy Building! 🚀**
