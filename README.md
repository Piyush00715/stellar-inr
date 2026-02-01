# 🚀 Decentralized Remittance dApp (Stellar Testnet)

## 📌 Project Description
This project is a **decentralized remittance dApp** built on the **Stellar Testnet** to demonstrate **fast, low‑cost cross‑border money transfers** using an **INR‑pegged stable token**.

The application showcases how blockchain‑based payments can reduce fees, settlement time, and dependency on intermediaries in traditional remittance systems, especially for transfers **to India**.

This is a **hackathon MVP**, focused on core payment functionality with a clear roadmap for Soroban smart contracts and regulated fiat on/off‑ramps.

---

## ❓ Problem We Are Solving
Traditional cross‑border remittance systems:
- Charge **high fees (5–7%)**
- Take **hours or days** to settle
- Rely on multiple intermediaries
- Lack transparency for end users

For users sending money to India, this results in **loss of value, delays, and poor accessibility**.

---

## 💡 Our Solution
We leverage **Stellar’s fast and low‑fee blockchain network** to enable:
- **Instant settlement (3–5 seconds)**
- **Near‑zero transaction fees**
- **Transparent, on‑chain transactions**
- **INR‑denominated value transfer** using an INR‑pegged test asset

This demonstrates a scalable foundation for next‑generation remittance infrastructure.

---

## ✨ Features
- **INR‑Pegged Token Transfers**
  - Demonstrates INR‑denominated remittance using a Stellar testnet asset
- **Instant Settlement**
  - Transactions finalize in seconds on Stellar
- **Ultra‑Low Fees**
  - Significantly cheaper than traditional remittance systems
- **Wallet‑to‑Wallet Transfers**
  - Fully non‑custodial transfers
- **Transparent & Verifiable**
  - Transactions viewable on Stellar Explorer
- **Simple & Focused UX**
  - Minimal UI for sending, receiving, and viewing balances

---

## ⚙️ How It Works (High Level)

1. **Issuer Account**
   - Creates (issues) the INR‑pegged test asset
2. **Distributor Account**
   - Holds and distributes the INR token
3. **Token Transfers**
   - Executed using Stellar’s native **Payment operations**
4. **Balance Tracking**
   - Balances are read directly from the Stellar ledger

> ⚠️ This MVP runs entirely on **Stellar Testnet** and does not use real money.

---

## 🧩 Smart Contract / Blockchain Design

### Current MVP
- Uses **native Stellar operations**
  - `send_token` → Stellar Payment operation
  - `get_balance` → Ledger balance via Horizon API
- No custom Soroban logic is required for the MVP

### Future Design
- **Soroban smart contracts** for:
  - Escrow‑based remittances
  - Conditional transfers
  - Compliance‑aware logic

---

## 🏗 Architecture Overview

### High‑Level Architecture

User Wallet (Freighter)
|
v
Frontend (React App)
|
v
Stellar Network (Testnet)
|
+--> Issuer Account (INRTEST creation)
|
+--> Distributor Account (Token distribution)


### Components
- **Frontend (React)**
  - Wallet connection
  - Token transfer UI
  - Balance & transaction display
- **Blockchain Layer**
  - Stellar Testnet
  - Custom asset using Issuer–Distributor model
- **Explorer / APIs**
  - Stellar Expert
  - Horizon API for ledger data

---

## 📍 Contract / Asset Details (Testnet)

- **Network:** Stellar Testnet  
- **Asset Code:** `INRTEST`  
- **Issuer Address:** `<ISSUER_PUBLIC_KEY>`  
- **Distributor Address:** `<DISTRIBUTOR_PUBLIC_KEY>`

> Replace the placeholders with your actual testnet public keys.

---

## 🛠 Tech Stack
- **Blockchain:** Stellar Testnet
- **Token Model:** Issuer–Distributor
- **Wallet:** Freighter (Testnet)
- **Frontend:** React
- **Explorer:** Stellar Expert

---

## 🔮 Future Scope
- Soroban‑based escrow and conditional payments
- Fiat on/off‑ramps via regulated anchors
- UPI and bank payout integration for India
- KYC & compliance integrations
- Mobile‑first UX for broader accessibility
- Expansion to multiple remittance corridors

---

## 🛣 Roadmap & Plans

### Phase 1 – Hackathon MVP
- INR‑pegged test asset
- Wallet‑to‑wallet remittance
- Live demo on Stellar Testnet

### Phase 2
- Soroban escrow contracts
- Improved UX and analytics

### Phase 3
- Regulated fiat on/off‑ramps
- UPI integration
- Mainnet readiness

---

## ⚠️ Disclaimer
This project is a **hackathon prototype** built for educational and demonstration purposes only.  
All assets exist **only on Stellar Testnet** and have **no real monetary value**.


