# Running the Application

## Quick Start

### 1. Install Dependencies

```bash
npm install
```

### 2. Set Up Environment Variables

Make sure your `.env.local` file has:

```env
# Stellar Network
STELLAR_NETWORK=testnet
HORIZON_URL=https://horizon-testnet.stellar.org
SOROBAN_RPC_URL=https://soroban-testnet.stellar.org

# Contract IDs (from deployment)
TOKEN_CONTRACT_ID=CBEWURGFLHZ5S4HF63DCNA5AAZPEBS5W4MMLV4CQFZ7ELUWM5RIZK2V3
REMITTANCE_CONTRACT_ID=CBHNRABJQEO4ONOI26ZB7UNT3S2FQRFHXX2VB56UPQJTANX2MVECFED4

# Account Keys (NEVER commit these!)
ISSUER_SECRET_KEY=YOUR_ISSUER_SECRET_KEY
DISTRIBUTOR_SECRET_KEY=YOUR_DISTRIBUTOR_SECRET_KEY

# Backend Configuration
BACKEND_PORT=3001
BACKEND_API_URL=http://localhost:3001/api

# Frontend Configuration (Vite)
VITE_HORIZON_URL=https://horizon-testnet.stellar.org
VITE_SOROBAN_RPC_URL=https://soroban-testnet.stellar.org
VITE_TOKEN_CONTRACT_ID=CBEWURGFLHZ5S4HF63DCNA5AAZPEBS5W4MMLV4CQFZ7ELUWM5RIZK2V3
VITE_REMITTANCE_CONTRACT_ID=CBHNRABJQEO4ONOI26ZB7UNT3S2FQRFHXX2VB56UPQJTANX2MVECFED4
VITE_BACKEND_API_URL=http://localhost:3001/api
```

### 3. Run Both Frontend and Backend

**Option A: Run Both Together (Recommended)**
```bash
npm run dev:all
```

This will start:
- Backend server on `http://localhost:3001`
- Frontend on `http://localhost:5173` (or next available port)

**Option B: Run Separately**

Terminal 1 - Backend:
```bash
npm run dev:backend
```

Terminal 2 - Frontend:
```bash
npm run dev
```

## API Endpoints

### Health Check
- `GET http://localhost:3001/api/health` - Basic health check
- `GET http://localhost:3001/api/health/network` - Network connectivity check

### Token Operations
- `GET http://localhost:3001/api/token/balance/:address` - Get token balance
- `GET http://localhost:3001/api/token/info` - Get token contract info

### Remittance Operations
- `POST http://localhost:3001/api/remittance/initiate` - Initiate remittance
  ```json
  {
    "senderSecretKey": "S...",
    "recipientAddress": "G...",
    "amount": "100.00",
    "metadata": { "purpose": "remittance" }
  }
  ```
- `POST http://localhost:3001/api/remittance/complete` - Complete remittance
  ```json
  {
    "remittanceId": "123",
    "completerSecretKey": "S..."
  }
  ```
- `GET http://localhost:3001/api/remittance/status/:remittanceId` - Get remittance status

## Development

### Backend Development
- Server code: `server/`
- Routes: `server/routes/`
- Stellar services: `backend/stellar/`

### Frontend Development
- React components: `src/components/`
- API service: `src/services/api.ts`
- Hooks: `src/hooks/useStellar.ts`
- Config: `src/config/stellar.ts`

## Troubleshooting

### Backend won't start
- Check if port 3001 is available
- Verify `.env.local` has all required variables
- Check contract IDs are correct

### Frontend can't connect to backend
- Verify `VITE_BACKEND_API_URL` in `.env.local`
- Check backend is running on port 3001
- Check CORS settings (should allow localhost)

### Contract calls failing
- Verify contract IDs in `.env.local`
- Check network is set to `testnet`
- Ensure accounts are funded with testnet XLM

## Production Build

### Build Frontend
```bash
npm run build
```

### Build Backend
```bash
npm run build:server
npm run start:server
```

## Security Notes

⚠️ **IMPORTANT**: 
- Never commit `.env.local` to git
- Never expose secret keys in frontend code
- In production, use proper wallet signing (Freighter) instead of sending secret keys
- Use environment-specific configurations
