# PowerShell script to generate a secure JWT secret

Write-Host "Generating JWT Secret..." -ForegroundColor Green
Write-Host ""

# Generate random bytes and convert to base64
$bytes = New-Object byte[] 64
$rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()
$rng.GetBytes($bytes)
$secret = [Convert]::ToBase64String($bytes)

Write-Host "JWT_SECRET=$secret" -ForegroundColor Yellow
Write-Host ""
Write-Host "Copy the JWT_SECRET value above and set it as an environment variable in your deployment platform." -ForegroundColor Cyan

