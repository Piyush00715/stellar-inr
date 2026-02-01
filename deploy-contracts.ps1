# PowerShell script to deploy contracts to Stellar testnet
# Make sure you have ISSUER_SECRET_KEY set in your .env.local file

# Load environment variables from .env.local if it exists
if (Test-Path ".env.local") {
    Get-Content ".env.local" | ForEach-Object {
        if ($_ -match '^\s*([^#][^=]+)=(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            [Environment]::SetEnvironmentVariable($key, $value, "Process")
        }
    }
}

# Check if secret key is set
if (-not $env:ISSUER_SECRET_KEY) {
    Write-Host "ERROR: ISSUER_SECRET_KEY not found!" -ForegroundColor Red
    Write-Host "Please set it in .env.local or run:" -ForegroundColor Yellow
    Write-Host '  $env:ISSUER_SECRET_KEY = "YOUR_SECRET_KEY_HERE"' -ForegroundColor Yellow
    exit 1
}

Write-Host "Deploying contracts to testnet..." -ForegroundColor Green
Write-Host ""

# Navigate to contracts directory
Set-Location contracts

# Deploy Token Contract
Write-Host "Deploying INR Token Contract..." -ForegroundColor Cyan
$TOKEN_CONTRACT_ID = soroban contract deploy `
    --wasm target/wasm32v1-none/release/inr_token.wasm `
    --source-account $env:ISSUER_SECRET_KEY `
    --network testnet `
    --id

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Token Contract deployed!" -ForegroundColor Green
    Write-Host "Token Contract ID: $TOKEN_CONTRACT_ID" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Add this to your .env.local:" -ForegroundColor Cyan
    Write-Host "TOKEN_CONTRACT_ID=$TOKEN_CONTRACT_ID" -ForegroundColor White
} else {
    Write-Host "❌ Token Contract deployment failed!" -ForegroundColor Red
    exit 1
}

# Deploy Remittance Contract
Write-Host ""
Write-Host "Deploying Remittance Contract..." -ForegroundColor Cyan
$REMITTANCE_CONTRACT_ID = soroban contract deploy `
    --wasm target/wasm32v1-none/release/remittance.wasm `
    --source-account $env:ISSUER_SECRET_KEY `
    --network testnet `
    --id

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Remittance Contract deployed!" -ForegroundColor Green
    Write-Host "Remittance Contract ID: $REMITTANCE_CONTRACT_ID" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Add this to your .env.local:" -ForegroundColor Cyan
    Write-Host "REMITTANCE_CONTRACT_ID=$REMITTANCE_CONTRACT_ID" -ForegroundColor White
} else {
    Write-Host "❌ Remittance Contract deployment failed!" -ForegroundColor Red
    exit 1
}

# Go back to root directory
Set-Location ..

Write-Host ""
Write-Host "🎉 All contracts deployed successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Add the contract IDs to your .env.local file" -ForegroundColor White
Write-Host "2. Initialize the contracts (see QUICKSTART.md Step 5)" -ForegroundColor White
