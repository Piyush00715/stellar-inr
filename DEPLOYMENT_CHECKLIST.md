# Deployment Checklist

Use this checklist to ensure everything is set up correctly before deploying to testnet.

## Pre-Deployment

### Environment Setup
- [ ] Rust installed (`rustc --version`)
- [ ] Soroban CLI installed (`soroban --version`)
- [ ] Node.js installed (`node --version` - should be v18+)
- [ ] Dependencies installed (`npm install`)

### Account Setup
- [ ] Issuer account created and funded with testnet XLM
  - Public Key: `GCWCPJZUE3GIPGLYMX6SHDEFRNHGQZSFSYL3G34AOWWAPZTA4GHLKEGG`
  - Secret Key: Added to `.env.local` as `ISSUER_SECRET_KEY`
- [ ] Distributor account created and funded with testnet XLM
  - Public Key: `GA3IGU5LOG2ACMMYZEIM2UO6EOYMQI24GB6SBETT3WN5A45JLYIPSOPI`
  - Secret Key: Added to `.env.local` as `DISTRIBUTOR_SECRET_KEY`
- [ ] Test user accounts created (optional, for testing)

### Configuration
- [ ] `.env.local` file created from `env.example`
- [ ] All secret keys added to `.env.local`
- [ ] Network set to `testnet` (not mainnet!)
- [ ] Horizon URL set to testnet
- [ ] Soroban RPC URL set to testnet

## Contract Deployment

### Build Contracts
- [ ] Navigate to `contracts/` directory
- [ ] Run `cargo build --target wasm32-unknown-unknown --release`
- [ ] Verify WASM files created:
  - `contracts/inr_token/target/wasm32-unknown-unknown/release/inr_token.wasm`
  - `contracts/remittance/target/wasm32-unknown-unknown/release/remittance.wasm`

### Deploy Contracts
- [ ] Soroban CLI configured for testnet:
  ```bash
  soroban config network add testnet \
    --rpc-url https://soroban-testnet.stellar.org \
    --network-passphrase "Test SDF Network ; September 2015"
  ```
- [ ] Deploy INR Token Contract
  - Contract ID saved to `.env.local` as `TOKEN_CONTRACT_ID`
- [ ] Deploy Remittance Contract
  - Contract ID saved to `.env.local` as `REMITTANCE_CONTRACT_ID`

### Initialize Contracts
- [ ] Initialize Token Contract with issuer and distributor addresses
- [ ] Initialize Remittance Contract with token contract address
- [ ] Verify initialization successful (no errors)

### Mint Test Tokens
- [ ] Mint tokens to distributor account
- [ ] Verify balance using contract `balance_of` function
- [ ] Mint tokens to test user accounts (if needed)

## Frontend Configuration

- [ ] `src/config/stellar.ts` has correct issuer address
- [ ] `src/config/stellar.ts` has correct distributor address
- [ ] Contract IDs added to `.env.local`:
  - `VITE_TOKEN_CONTRACT_ID`
  - `VITE_REMITTANCE_CONTRACT_ID`
- [ ] Backend API URL configured (if using separate backend):
  - `VITE_BACKEND_API_URL`

## Backend Setup (if using separate backend server)

- [ ] Backend server created (Express/Node.js)
- [ ] Backend services imported from `backend/stellar/`
- [ ] API endpoints created:
  - `POST /api/remittance/initiate`
  - `POST /api/remittance/complete`
  - `GET /api/remittance/status/:id`
  - `GET /api/balance/:address`
- [ ] Environment variables loaded in backend
- [ ] CORS configured (if frontend on different port)
- [ ] Error handling implemented

## Testing

### Contract Tests
- [ ] Run `cd contracts/inr_token && cargo test` - all tests pass
- [ ] Run `cd contracts/remittance && cargo test` - all tests pass

### Integration Tests
- [ ] Frontend starts without errors (`npm run dev`)
- [ ] Wallet connection works (Freighter or similar)
- [ ] Balance query works
- [ ] Token transfer works
- [ ] Remittance initiation works
- [ ] Remittance completion works
- [ ] Transaction appears on Stellar Explorer

### Manual Verification
- [ ] Check contract on explorer:
  - `https://stellar.expert/explorer/testnet/contract/{CONTRACT_ID}`
- [ ] Verify issuer can mint tokens
- [ ] Verify distributor can transfer tokens
- [ ] Verify users can transfer their own tokens
- [ ] Verify remittance flow end-to-end
- [ ] Check events emitted on explorer

## Security Verification

- [ ] No secret keys in code (grep for "SA" or "SB" in code files)
- [ ] `.env.local` in `.gitignore`
- [ ] No secret keys in frontend code
- [ ] All signing operations via backend or wallet
- [ ] Network set to testnet (not mainnet)
- [ ] Input validation working
- [ ] Authorization checks working

## Documentation

- [ ] README reviewed: `STELLAR_REMITTANCE_README.md`
- [ ] Quick start guide reviewed: `QUICKSTART.md`
- [ ] Implementation summary reviewed: `IMPLEMENTATION_SUMMARY.md`
- [ ] Environment variables documented
- [ ] Deployment process documented

## Final Checks

- [ ] All contracts deployed to **TESTNET** (not mainnet!)
- [ ] All accounts funded with testnet XLM
- [ ] All contract IDs saved to `.env.local`
- [ ] Frontend can connect to backend (if applicable)
- [ ] Wallet integration working
- [ ] Transactions visible on explorer
- [ ] No errors in console
- [ ] Ready for demo/testing

---

## Common Issues & Solutions

### "Contract not initialized"
- **Solution**: Run `initialize` function on contract

### "Only issuer can mint"
- **Solution**: Use issuer secret key, not distributor

### "Insufficient balance for fees"
- **Solution**: Fund account with testnet XLM

### Frontend can't find contracts
- **Solution**: Check `VITE_TOKEN_CONTRACT_ID` and `VITE_REMITTANCE_CONTRACT_ID` in `.env.local`

### Backend connection failed
- **Solution**: Check `VITE_BACKEND_API_URL` and ensure backend is running

---

**✅ When all items are checked, you're ready to deploy!**

**Remember: TESTNET ONLY - Never use mainnet credentials!**
