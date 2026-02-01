# Script to fix port 3001 issue
# Run this in PowerShell

Write-Host "Checking port 3001..." -ForegroundColor Cyan

$connection = Get-NetTCPConnection -LocalPort 3001 -ErrorAction SilentlyContinue

if ($connection) {
    $processId = $connection.OwningProcess
    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
    
    if ($process) {
        Write-Host "Found process using port 3001:" -ForegroundColor Yellow
        Write-Host "  PID: $($process.Id)" -ForegroundColor White
        Write-Host "  Name: $($process.ProcessName)" -ForegroundColor White
        Write-Host "  Path: $($process.Path)" -ForegroundColor White
        Write-Host ""
        Write-Host "Killing process..." -ForegroundColor Cyan
        Stop-Process -Id $processId -Force
        Write-Host "✅ Process killed. Port 3001 is now free." -ForegroundColor Green
    } else {
        Write-Host "⚠️  Process not found, but port is in use." -ForegroundColor Yellow
    }
} else {
    Write-Host "✅ Port 3001 is free." -ForegroundColor Green
}

Write-Host ""
Write-Host "You can now run: npm run dev:all" -ForegroundColor Cyan
