# Stellar INR Remittance dApp - Technical Documentation

## 🎯 System Overview

This is a **TESTNET-ONLY** decentralized remittance application built on Stellar using Soroban smart contracts. The system enables low-cost, instant cross-border remittances to India using an INR-pegged stablecoin.

### Architecture

```
┌─────────────┐
│  Frontend   │  React + TypeScript (Vite)
│  (React)    │  - Wallet connection
└──────┬──────┘  - Balance display
       │         - Transaction forms
       │         - NO secret keys
       │
       │ HTTP/API
       │
┌──────▼──────────────────┐
│  Backend Services        │  TypeScript
│  (Node.js/Express)       │  - Horizon Client
│                          │  - Soroban Client
│                          │  - Remittance Service
│                          │  - Secret key handling
└──────┬───────────────────┘
       │
       │ Stellar Network (TESTNET)
       │
┌──────▼──────────────────┐
│  Soroban Smart Contracts │  Rust
│  - INR Token Contract    │  - Token minting
│  - Remittance Contract   │  - Transfer logic
│                          │  - Compliance hooks
└──────────────────────────┘
```

### Key Components

1. **INR Token Contract** (`contracts/inr_token/`)
   - Fungible token representing INR (1 token = 1 INR)
   - Issued only by the Issuer account
   - Distributor authorized for distribution
   - Functions: `initialize`, `mint`, `transfer`, `balance_of`

2. **Remittance Contract** (`contracts/remittance/`)
   - Handles remittance flow logic
   - KYC verification hooks (mocked)
   - Compliance event logging
   - Functions: `initiate_remittance`, `complete_remittance`, `get_remittance_status`

3. **Backend Services** (`backend/stellar/`)
   - `horizonClient.ts`: Stellar Horizon API interactions
   - `sorobanClient.ts`: Soroban contract invocations
   - `remittanceService.ts`: High-level remittance operations

4. **Frontend Configuration** (`src/config/stellar.ts`)
   - Network configuration (TESTNET)
   - Issuer and Distributor public keys
   - Contract addresses (set after deployment)
   - NO secret keys

### Account Structure

**Issuer Account** (INR Stablecoin Issuer)
- Public Key: `GCWCPJZUE3GIPGLYMX6SHDEFRNHGQZSFSYL3G34AOWWAPZTA4GHLKEGG`
- Role: Mints new INR tokens
- Secret Key: Stored in `.env.local` as `ISSUER_SECRET_KEY`

**Distributor Account** (Liquidity + User Distribution)
- Public Key: `GA3IGU5LOG2ACMMYZEIM2UO6EOYMQI24GB6SBETT3WN5A45JLYIPSOPI`
- Role: Distributes tokens to users, provides liquidity
- Secret Key: Stored in `.env.local` as `DISTRIBUTOR_SECRET_KEY`

---

## 📋 Prerequisites

### Required Software

1. **Rust** (for Soroban contracts)
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   ```

2. **Soroban CLI**
   ```bash
   cargo install --locked soroban-cli
   ```

3. **Node.js** (v18+)
   ```bash
   # Using nvm
   nvm install 18
   nvm use 18
   ```

4. **Stellar Testnet Account**
   - Get testnet XLM from: https://www.stellar.org/laboratory/#account-creator?network=test

### Environment Setup

1. Copy environment template:
   ```bash
   cp env.example .env.local
   ```

2. Fill in secret keys in `.env.local`:
   ```env
   ISSUER_SECRET_KEY=your_issuer_secret_key_here
   DISTRIBUTOR_SECRET_KEY=your_distributor_secret_key_here
   ```

3. Install dependencies:
   ```bash
   npm install
   ```

---

## 🏗️ Soroban Smart Contract Design

### INR Token Contract

**Purpose**: Fungible token representing Indian Rupee (1 token = 1 INR)

**Storage**:
- `ISSUER`: Issuer account address
- `DISTRIBUTOR`: Distributor account address
- `BALANCE`: Per-address token balances

**Functions**:

1. **`initialize(issuer, distributor)`**
   - Sets issuer and distributor addresses
   - Can only be called once
   - Required before any other operations

2. **`mint(to, amount)`**
   - Mints new tokens to specified address
   - Only issuer can call
   - Emits `MINT` event for auditability

3. **`transfer(from, to, amount)`**
   - Transfers tokens between addresses
   - Authorized callers: `from` address, issuer, or distributor
   - Validates sufficient balance
   - Emits `TRANSFER` event

4. **`balance_of(address)`**
   - Returns token balance for an address
   - View function (no transaction required)

### Remittance Contract

**Purpose**: Manages remittance transactions with compliance hooks

**Storage**:
- `TOKEN_CONTRACT`: Address of INR token contract
- `REMITTANCE`: Remittance records by ID

**Functions**:

1. **`initialize(token_contract)`**
   - Sets token contract address
   - Required before remittance operations

2. **`initiate_remittance(sender, recipient, amount, metadata)`**
   - Verifies KYC (mocked, always returns true for testnet)
   - Creates remittance record
   - Emits `REMITTANCE_INITIATED` event
   - Returns remittance ID

3. **`complete_remittance(remittance_id)`**
   - Marks remittance as completed
   - Emits `REMITTANCE_COMPLETED` event

4. **`get_remittance_status(remittance_id)`**
   - Returns remittance record
   - View function

**Compliance Features**:
- KYC verification hook (mocked, ready for API integration)
- Metadata logging for RBI-style audits
- Event emission for audit trail

---

## 💻 Contract Code (Rust)

### Building Contracts

```bash
# Navigate to contracts directory
cd contracts

# Build all contracts
cargo build --target wasm32-unknown-unknown --release

# Build individual contract
cd inr_token
cargo build --target wasm32-unknown-unknown --release
```

### Deploying Contracts

**Prerequisites**: 
- Funded issuer account with XLM for fees
- Soroban CLI configured for testnet

```bash
# Set network to testnet
soroban network add testnet --rpc-url https://soroban-testnet.stellar.org --network-passphrase "Test SDF Network ; September 2015"

# Deploy INR Token Contract
soroban contract deploy \
  --wasm target/wasm32-unknown-unknown/release/inr_token.wasm \
  --source-account ISSUER_SECRET_KEY \
  --network testnet

# Save the contract ID to .env.local as TOKEN_CONTRACT_ID

# Deploy Remittance Contract
soroban contract deploy \
  --wasm target/wasm32-unknown-unknown/release/remittance.wasm \
  --source-account ISSUER_SECRET_KEY \
  --network testnet

# Save the contract ID to .env.local as REMITTANCE_CONTRACT_ID
```

### Initializing Contracts

```bash
# Initialize Token Contract
soroban contract invoke \
  --id TOKEN_CONTRACT_ID \
  --source-account ISSUER_SECRET_KEY \
  --network testnet \
  -- initialize \
  --issuer GCWCPJZUE3GIPGLYMX6SHDEFRNHGQZSFSYL3G34AOWWAPZTA4GHLKEGG \
  --distributor GA3IGU5LOG2ACMMYZEIM2UO6EOYMQI24GB6SBETT3WN5A45JLYIPSOPI

# Initialize Remittance Contract
soroban contract invoke \
  --id REMITTANCE_CONTRACT_ID \
  --source-account ISSUER_SECRET_KEY \
  --network testnet \
  -- initialize \
  --token_contract TOKEN_CONTRACT_ID
```

### Testing Contracts

```bash
# Run unit tests
cd contracts/inr_token
cargo test

cd ../remittance
cargo test
```

---

## 🔧 Backend Integration (TypeScript)

### Setup

The backend services are located in `backend/stellar/`. They can be integrated into a Node.js/Express API server.

### Example Usage

```typescript
import { createTestnetHorizonClient } from './backend/stellar/horizonClient';
import { createTestnetSorobanClient } from './backend/stellar/sorobanClient';
import { RemittanceService } from './backend/stellar/remittanceService';
import { Keypair } from '@stellar/stellar-sdk';

// Initialize clients
const horizonClient = createTestnetHorizonClient();
const sorobanClient = createTestnetSorobanClient(horizonClient);

// Initialize remittance service
const remittanceService = new RemittanceService(
  horizonClient,
  sorobanClient,
  process.env.TOKEN_CONTRACT_ID!,
  process.env.REMITTANCE_CONTRACT_ID!
);

// Example: Initiate remittance
const result = await remittanceService.initiateRemittance({
  senderSecretKey: process.env.USER_SECRET_KEY!,
  recipientAddress: 'G...',
  amount: '1000.00',
  metadata: {
    purpose: 'family_support',
    country: 'IN',
  },
});

console.log('Remittance ID:', result.remittanceId);
console.log('Transaction Hash:', result.transactionHash);
```

### API Endpoints (Example Structure)

```typescript
// POST /api/remittance/initiate
// Body: { senderSecretKey, recipientAddress, amount, metadata? }
// Returns: { remittanceId, transactionHash, status, timestamp }

// POST /api/remittance/complete
// Body: { remittanceId, completerSecretKey }
// Returns: { transactionHash }

// GET /api/remittance/status/:remittanceId
// Returns: { id, sender, recipient, amount, status, timestamp, kycVerified, metadata }

// GET /api/balance/:address
// Returns: { balance: string }
```

---

## 🎨 Frontend Configuration Changes

### Updated Files

**`src/config/stellar.ts`** - Contains:
- Network configuration (TESTNET)
- Issuer public key: `GCWCPJZUE3GIPGLYMX6SHDEFRNHGQZSFSYL3G34AOWWAPZTA4GHLKEGG`
- Distributor public key: `GA3IGU5LOG2ACMMYZEIM2UO6EOYMQI24GB6SBETT3WN5A45JLYIPSOPI`
- Contract addresses (from environment variables)
- Explorer URLs

### Integration Points

The frontend should:
1. **Read contract addresses** from `STELLAR_CONFIG.contracts`
2. **Use backend API** for all signing operations (never sign in frontend)
3. **Display balances** by calling backend API
4. **Show transaction links** using `STELLAR_CONFIG.explorer.transaction(hash)`

### Example Frontend Hook

```typescript
// src/hooks/useRemittance.ts
import { STELLAR_CONFIG } from '@/config/stellar';

export function useRemittance() {
  const initiateRemittance = async (
    recipient: string,
    amount: string
  ) => {
    // Call backend API (user signs via Freighter or backend)
    const response = await fetch(`${STELLAR_CONFIG.backend.apiUrl}/remittance/initiate`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        recipientAddress: recipient,
        amount,
      }),
    });
    return response.json();
  };

  return { initiateRemittance };
}
```

---

## 🔒 Security Design & Key Management

### Secret Key Handling

**NEVER**:
- ❌ Commit secret keys to git
- ❌ Store keys in frontend code
- ❌ Log keys in console
- ❌ Send keys over unencrypted connections

**ALWAYS**:
- ✅ Store keys in `.env.local` (gitignored)
- ✅ Use environment variables
- ✅ Sign transactions on backend or via wallet (Freighter)
- ✅ Validate all inputs
- ✅ Use HTTPS in production

### Key Storage

```
.env.local (gitignored)
├── ISSUER_SECRET_KEY=SA... (issuer account)
├── DISTRIBUTOR_SECRET_KEY=SA... (distributor account)
└── USER_SECRET_KEY=SA... (user accounts - if needed)
```

### Authorization Model

1. **Token Minting**: Only issuer can mint
2. **Token Transfer**: 
   - Owner can transfer their own tokens
   - Issuer can transfer on behalf of users
   - Distributor can transfer for distribution
3. **Remittance**: Any verified user can initiate

### Replay Attack Prevention

- Stellar transactions include sequence numbers
- Each transaction is unique (cannot be replayed)
- Soroban contracts use ledger sequence for remittance IDs

### Input Validation

All inputs are validated:
- Address format: `G[55 chars]`
- Amount: Positive numbers only
- Metadata: JSON string format
- KYC: Verified before remittance (mocked for testnet)

---

## 🧪 Local Testing Instructions

### 1. Setup Environment

```bash
# Install dependencies
npm install

# Install Rust and Soroban CLI (if not already installed)
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
cargo install --locked soroban-cli

# Copy and configure environment
cp env.example .env.local
# Edit .env.local and add your secret keys
```

### 2. Build Contracts

```bash
cd contracts
cargo build --target wasm32-unknown-unknown --release
```

### 3. Deploy to Testnet

```bash
# Configure Soroban for testnet
soroban network add testnet --rpc-url https://soroban-testnet.stellar.org --network-passphrase "Test SDF Network ; September 2015"

# Deploy contracts (see "Deploying Contracts" section above)
# Save contract IDs to .env.local
```

### 4. Initialize Contracts

```bash
# Initialize token contract
soroban contract invoke \
  --id $TOKEN_CONTRACT_ID \
  --source-account $ISSUER_SECRET_KEY \
  --network testnet \
  -- initialize \
  --issuer GCWCPJZUE3GIPGLYMX6SHDEFRNHGQZSFSYL3G34AOWWAPZTA4GHLKEGG \
  --distributor GA3IGU5LOG2ACMMYZEIM2UO6EOYMQI24GB6SBETT3WN5A45JLYIPSOPI

# Initialize remittance contract
soroban contract invoke \
  --id $REMITTANCE_CONTRACT_ID \
  --source-account $ISSUER_SECRET_KEY \
  --network testnet \
  -- initialize \
  --token_contract $TOKEN_CONTRACT_ID
```

### 5. Mint Test Tokens

```bash
# Mint tokens to distributor
soroban contract invoke \
  --id $TOKEN_CONTRACT_ID \
  --source-account $ISSUER_SECRET_KEY \
  --network testnet \
  -- mint \
  --to GA3IGU5LOG2ACMMYZEIM2UO6EOYMQI24GB6SBETT3WN5A45JLYIPSOPI \
  --amount 1000000000  # 1000 INR (with 6 decimals)
```

### 6. Run Frontend

```bash
npm run dev
```

### 7. Test Remittance Flow

1. Connect wallet (Freighter)
2. Request tokens from distributor (via backend API)
3. Initiate remittance to recipient address
4. Check transaction on Stellar Explorer

### Unit Tests

```bash
# Test contracts
cd contracts/inr_token && cargo test
cd ../remittance && cargo test

# Test frontend (if tests exist)
npm test
```

---

## 📊 Example Testnet Transaction Walkthrough

### Scenario: Send 100 INR to Recipient

1. **Prerequisites**:
   - Issuer account funded with XLM
   - Contracts deployed and initialized
   - Distributor has tokens

2. **Mint Tokens to User**:
   ```bash
   soroban contract invoke \
     --id $TOKEN_CONTRACT_ID \
     --source-account $ISSUER_SECRET_KEY \
     --network testnet \
     -- mint \
     --to USER_PUBLIC_KEY \
     --amount 100000000  # 100 INR
   ```

3. **Initiate Remittance**:
   ```bash
   soroban contract invoke \
     --id $REMITTANCE_CONTRACT_ID \
     --source-account $USER_SECRET_KEY \
     --network testnet \
     -- initiate_remittance \
     --sender USER_PUBLIC_KEY \
     --recipient RECIPIENT_PUBLIC_KEY \
     --amount 100000000 \
     --metadata '{"purpose":"family_support","country":"IN"}'
   ```

4. **Check Transaction**:
   - Visit: `https://stellar.expert/explorer/testnet/tx/{tx_hash}`
   - Verify remittance status on contract

5. **Complete Remittance** (if needed):
   ```bash
   soroban contract invoke \
     --id $REMITTANCE_CONTRACT_ID \
     --source-account $USER_SECRET_KEY \
     --network testnet \
     -- complete_remittance \
     --remittance_id {remittance_id}
   ```

---

## 🚀 Future Extensions

### 1. UPI Off-Ramp Integration

**Goal**: Allow users to convert INR tokens to fiat via UPI

**Implementation**:
- Partner with regulated anchor
- Implement off-ramp API endpoint
- KYC/AML compliance checks
- UPI payment gateway integration

**Contract Changes**:
- Add `redeem` function to token contract
- Implement redemption flow with anchor verification

### 2. Zero-Knowledge Privacy

**Goal**: Add privacy layer for transaction amounts/recipients

**Implementation**:
- Integrate ZK-SNARKs library (e.g., zk-STARKs)
- Create privacy contract wrapper
- Implement shielded transfers
- Maintain compliance (selective disclosure)

**Contract Changes**:
- New privacy contract
- Modified remittance flow with ZK proofs

### 3. Multi-Currency Support

**Goal**: Support remittances in multiple currencies

**Implementation**:
- Generic token contract factory
- Currency-specific contracts
- Cross-currency swaps via DEX

### 4. Real KYC Integration

**Goal**: Replace mocked KYC with real verification

**Implementation**:
- Integrate KYC provider API (e.g., Sumsub, Onfido)
- Store verification status on-chain or off-chain
- Implement verification expiry
- Handle verification updates

**Code Changes**:
- Update `verify_kyc` in remittance contract
- Add KYC status storage
- Implement verification refresh mechanism

### 5. Compliance Dashboard

**Goal**: RBI-style audit and compliance reporting

**Implementation**:
- Compliance database (PostgreSQL)
- Event streaming from contracts
- Dashboard for compliance officers
- Automated reporting

---

## ⚠️ Important Disclaimers

1. **TESTNET ONLY**: This code is for testnet use only. Never deploy to mainnet without:
   - Security audit
   - Compliance review
   - Legal consultation
   - Proper key management

2. **No Financial Advice**: This is a technical demonstration. Not financial or legal advice.

3. **Regulatory Compliance**: In production, ensure:
   - Proper licensing (if required)
   - KYC/AML compliance
   - RBI regulations (for India)
   - Cross-border remittance regulations

4. **Key Security**: Secret keys are your responsibility. Use hardware wallets or secure key management in production.

---

## 📚 Additional Resources

- [Stellar Documentation](https://developers.stellar.org/)
- [Soroban Documentation](https://soroban.stellar.org/docs)
- [Stellar SDK](https://stellar.github.io/js-stellar-sdk/)
- [Stellar Testnet](https://www.stellar.org/laboratory/)
- [Stellar Explorer](https://stellar.expert/)

---

## 🐛 Troubleshooting

### Contract Deployment Fails

- **Issue**: Insufficient XLM for fees
- **Solution**: Fund account with testnet XLM

### Contract Invocation Fails

- **Issue**: Contract not initialized
- **Solution**: Call `initialize` function first

### Balance Not Updating

- **Issue**: Wrong contract address
- **Solution**: Verify `TOKEN_CONTRACT_ID` in `.env.local`

### Frontend Can't Connect

- **Issue**: Backend not running or wrong URL
- **Solution**: Check `VITE_BACKEND_API_URL` in `.env.local`

---

## 📝 License

This project is for educational and hackathon purposes. Use at your own risk.

---

**Built for Stellar Community Fund Hackathon**  
**TESTNET ONLY - NOT FOR PRODUCTION USE**
