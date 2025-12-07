# Script to run both backend and frontend
# This script opens two PowerShell windows - one for backend, one for frontend

Write-Host "=== Starting Backend and Frontend ===" -ForegroundColor Green

$scriptRoot = $PSScriptRoot

# Start backend in a new window
Write-Host "`nStarting Backend in a new window..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$scriptRoot\backend'; `$env:Path += ';C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\bin'; mvnd spring-boot:run"

# Wait a bit for backend to start
Start-Sleep -Seconds 3

# Start frontend in a new window
Write-Host "Starting Frontend in a new window..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$scriptRoot\frontend'; flutter pub get; flutter run"

Write-Host "`n✅ Both applications are starting in separate windows" -ForegroundColor Green
Write-Host "Backend: http://localhost:8080" -ForegroundColor Yellow
Write-Host "Frontend: Will launch on your device/emulator" -ForegroundColor Yellow
Write-Host "`nPress any key to exit this window (applications will continue running)..." -ForegroundColor Cyan
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")


