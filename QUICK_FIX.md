# Quick Fix for Port 3001 Issue

## Problem
Port 3001 is already in use by another process.

## Solutions

### Option 1: Kill the Process Using Port 3001 (Recommended)

**Windows PowerShell:**
```powershell
# Find the process
$process = Get-NetTCPConnection -LocalPort 3001 | Select-Object -ExpandProperty OwningProcess
Get-Process -Id $process

# Kill it
Stop-Process -Id $process -Force
```

**Or use the helper script:**
```powershell
.\fix-port-issue.ps1
```

### Option 2: Change the Backend Port

1. Edit `.env.local` and add:
   ```env
   BACKEND_PORT=3002
   ```

2. Also update `VITE_BACKEND_API_URL`:
   ```env
   VITE_BACKEND_API_URL=http://localhost:3002/api
   ```

3. Restart the servers:
   ```bash
   npm run dev:all
   ```

### Option 3: Use a Different Port Temporarily

You can also just change the port in the command:
```bash
BACKEND_PORT=3002 npm run dev:backend
```

## Contract IDs Issue - FIXED ✅

I've updated the code to use the deployed contract IDs as defaults, so this warning won't stop the server. However, you should still add them to `.env.local`:

```env
TOKEN_CONTRACT_ID=CBEWURGFLHZ5S4HF63DCNA5AAZPEBS5W4MMLV4CQFZ7ELUWM5RIZK2V3
REMITTANCE_CONTRACT_ID=CBHNRABJQEO4ONOI26ZB7UNT3S2FQRFHXX2VB56UPQJTANX2MVECFED4
```

## After Fixing

Run again:
```bash
npm run dev:all
```

The server should start successfully on port 3001 (or your chosen port).
