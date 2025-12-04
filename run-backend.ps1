# Script to run the Spring Boot backend
# This script configures mvnd and runs the backend

Write-Host "=== Starting Spring Boot Backend ===" -ForegroundColor Green

# Navigate to backend directory
$backendDir = Join-Path $PSScriptRoot "backend"
if (-not (Test-Path $backendDir)) {
    Write-Host "❌ Backend directory not found: $backendDir" -ForegroundColor Red
    exit 1
}

Set-Location $backendDir

# Check for pom.xml
if (-not (Test-Path "pom.xml")) {
    Write-Host "❌ pom.xml not found in backend directory!" -ForegroundColor Red
    exit 1
}

# Add mvnd to PATH
$mvndPath = "C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\bin"
if (Test-Path $mvndPath) {
    $env:Path += ";$mvndPath"
    Write-Host "✅ mvnd added to PATH" -ForegroundColor Green
} else {
    Write-Host "⚠️  mvnd not found, trying mvn standard" -ForegroundColor Yellow
}

# Check Java
Write-Host "`nChecking Java..." -ForegroundColor Cyan
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "✅ $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Java not found!" -ForegroundColor Red
    exit 1
}

# Check Maven/mvnd
Write-Host "`nChecking Maven/mvnd..." -ForegroundColor Cyan
if (Get-Command mvnd -ErrorAction SilentlyContinue) {
    Write-Host "✅ Using mvnd (Maven Daemon)" -ForegroundColor Green
    $mavenCmd = "mvnd"
} elseif (Get-Command mvn -ErrorAction SilentlyContinue) {
    Write-Host "✅ Using mvn standard" -ForegroundColor Green
    $mavenCmd = "mvn"
} else {
    Write-Host "❌ Maven/mvnd not found!" -ForegroundColor Red
    Write-Host "Please install Maven or configure mvnd" -ForegroundColor Yellow
    exit 1
}

# Display information
Write-Host "`n=== Project Information ===" -ForegroundColor Cyan
Write-Host "Directory: $(Get-Location)" -ForegroundColor White
Write-Host "Maven Command: $mavenCmd" -ForegroundColor White
Write-Host "`nApplication will be available at: http://localhost:8080" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop`n" -ForegroundColor Yellow

# Run backend
Write-Host "=== Starting Application ===" -ForegroundColor Green
& $mavenCmd spring-boot:run

