# Script to run the Flutter frontend
# This script checks Flutter setup and runs the frontend

Write-Host "=== Starting Flutter Frontend ===" -ForegroundColor Green

# Navigate to frontend directory
$frontendDir = Join-Path $PSScriptRoot "frontend"
if (-not (Test-Path $frontendDir)) {
    Write-Host "❌ Frontend directory not found: $frontendDir" -ForegroundColor Red
    exit 1
}

Set-Location $frontendDir

# Check for pubspec.yaml
if (-not (Test-Path "pubspec.yaml")) {
    Write-Host "❌ pubspec.yaml not found in frontend directory!" -ForegroundColor Red
    exit 1
}

# Check Flutter
Write-Host "`nChecking Flutter..." -ForegroundColor Cyan
try {
    $flutterVersion = flutter --version 2>&1 | Select-Object -First 1
    Write-Host "✅ $flutterVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Flutter not found!" -ForegroundColor Red
    Write-Host "Please make sure Flutter is installed and in your PATH" -ForegroundColor Yellow
    exit 1
}

# Check Flutter doctor
Write-Host "`nRunning Flutter doctor..." -ForegroundColor Cyan
flutter doctor

# Install dependencies
Write-Host "`nInstalling dependencies..." -ForegroundColor Cyan
flutter pub get

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Failed to install dependencies!" -ForegroundColor Red
    exit 1
}

# Check available devices
Write-Host "`nChecking available devices..." -ForegroundColor Cyan
flutter devices

# Ask user which device to use
Write-Host "`n=== Starting Application ===" -ForegroundColor Green
Write-Host "The app will launch on the default device" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop`n" -ForegroundColor Yellow

# Run Flutter app
flutter run


