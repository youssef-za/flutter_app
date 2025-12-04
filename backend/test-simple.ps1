# Script de test simple pour vérifier que l'API fonctionne
# Usage: .\test-simple.ps1

$baseUrl = "http://localhost:8080/api"
$email = "test$(Get-Random)@example.com"
$password = "test123456"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Test Simple de l'API" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Inscription
Write-Host "1. Test d'inscription..." -ForegroundColor Yellow
try {
    $registerBody = @{
        fullName = "Test User"
        email = $email
        password = $password
    } | ConvertTo-Json

    $registerResponse = Invoke-RestMethod -Uri "$baseUrl/auth/register" `
        -Method Post `
        -ContentType "application/json" `
        -Body $registerBody
    
    $token = $registerResponse.token
    Write-Host "✓ Inscription réussie!" -ForegroundColor Green
    Write-Host "  Email: $email" -ForegroundColor Gray
    Write-Host "  Token: $($token.Substring(0, [Math]::Min(30, $token.Length)))..." -ForegroundColor Gray
} catch {
    Write-Host "✗ Erreur d'inscription: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 2: Connexion
Write-Host "2. Test de connexion..." -ForegroundColor Yellow
try {
    $loginBody = @{
        email = $email
        password = $password
    } | ConvertTo-Json

    $loginResponse = Invoke-RestMethod -Uri "$baseUrl/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginBody
    
    $token = $loginResponse.token
    Write-Host "✓ Connexion réussie!" -ForegroundColor Green
} catch {
    Write-Host "✗ Erreur de connexion: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# Test 3: Créer une émotion
Write-Host "3. Test de création d'émotion..." -ForegroundColor Yellow
try {
    $headers = @{
        "Authorization" = "Bearer $token"
    }

    $emotionBody = @{
        emotionType = "HAPPY"
        confidence = 0.75
    } | ConvertTo-Json

    $emotionResponse = Invoke-RestMethod -Uri "$baseUrl/emotions" `
        -Method Post `
        -ContentType "application/json" `
        -Headers $headers `
        -Body $emotionBody
    
    Write-Host "✓ Emotion créée!" -ForegroundColor Green
    Write-Host "  ID: $($emotionResponse.id)" -ForegroundColor Gray
    Write-Host "  Type: $($emotionResponse.emotionType)" -ForegroundColor Gray
    Write-Host "  Confiance: $($emotionResponse.confidence)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Erreur de création d'émotion: $_" -ForegroundColor Red
    Write-Host "  Détails: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Tests terminés!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Vérifiez les logs de l'application pour plus de détails." -ForegroundColor Yellow

