# Script PowerShell de test automatique pour l'API Medical Emotion Monitoring
# Usage: .\test-api.ps1

$BASE_URL = "http://localhost:8080/api"
$EMAIL = "test.user@example.com"
$PASSWORD = "testpassword123"
$FULL_NAME = "Test User"
$TOKEN = ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Test de l'API Medical Emotion Monitoring" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Fonction pour afficher les résultats
function Print-Result {
    param(
        [bool]$Success,
        [string]$Message
    )
    if ($Success) {
        Write-Host "✓ $Message" -ForegroundColor Green
    } else {
        Write-Host "✗ $Message" -ForegroundColor Red
    }
}

# 1. Test d'inscription
Write-Host "1. Test d'inscription..." -ForegroundColor Yellow
$registerBody = @{
    fullName = $FULL_NAME
    email = $EMAIL
    password = $PASSWORD
} | ConvertTo-Json

try {
    $registerResponse = Invoke-RestMethod -Uri "$BASE_URL/auth/register" `
        -Method Post `
        -ContentType "application/json" `
        -Body $registerBody
    
    $TOKEN = $registerResponse.token
    Print-Result $true "Inscription réussie"
    Write-Host "Token reçu: $($TOKEN.Substring(0, [Math]::Min(50, $TOKEN.Length)))..." -ForegroundColor Gray
} catch {
    Print-Result $false "Inscription échouée"
    Write-Host "Erreur: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# 2. Test de connexion
Write-Host "2. Test de connexion..." -ForegroundColor Yellow
$loginBody = @{
    email = $EMAIL
    password = $PASSWORD
} | ConvertTo-Json

try {
    $loginResponse = Invoke-RestMethod -Uri "$BASE_URL/auth/login" `
        -Method Post `
        -ContentType "application/json" `
        -Body $loginBody
    
    $TOKEN = $loginResponse.token
    Print-Result $true "Connexion réussie"
    Write-Host "Token: $($TOKEN.Substring(0, [Math]::Min(50, $TOKEN.Length)))..." -ForegroundColor Gray
} catch {
    Print-Result $false "Connexion échouée"
    Write-Host "Erreur: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""

# 3. Test de validation du token
Write-Host "3. Test de validation du token..." -ForegroundColor Yellow
$headers = @{
    "Authorization" = "Bearer $TOKEN"
}

try {
    $validateResponse = Invoke-RestMethod -Uri "$BASE_URL/auth/validate" `
        -Method Get `
        -Headers $headers
    
    Print-Result $true "Token valide"
} catch {
    Print-Result $false "Token invalide"
    Write-Host "Erreur: $_" -ForegroundColor Red
}

Write-Host ""

# 4. Test de création d'émotion
Write-Host "4. Test de création d'émotion..." -ForegroundColor Yellow
$emotionBody = @{
    emotionType = "HAPPY"
    confidence = 0.85
} | ConvertTo-Json

try {
    $emotionResponse = Invoke-RestMethod -Uri "$BASE_URL/emotions" `
        -Method Post `
        -ContentType "application/json" `
        -Headers $headers `
        -Body $emotionBody
    
    $EMOTION_ID = $emotionResponse.id
    Print-Result $true "Emotion créée (ID: $EMOTION_ID)"
} catch {
    Print-Result $false "Création d'émotion échouée"
    Write-Host "Erreur: $_" -ForegroundColor Red
}

Write-Host ""

# 5. Test de récupération d'émotion
if ($EMOTION_ID) {
    Write-Host "5. Test de récupération d'émotion (ID: $EMOTION_ID)..." -ForegroundColor Yellow
    try {
        $getEmotionResponse = Invoke-RestMethod -Uri "$BASE_URL/emotions/$EMOTION_ID" `
            -Method Get `
            -Headers $headers
        
        Print-Result $true "Récupération d'émotion réussie"
    } catch {
        Print-Result $false "Récupération échouée"
        Write-Host "Erreur: $_" -ForegroundColor Red
    }
    Write-Host ""
}

# 6. Test de récupération de l'historique
Write-Host "6. Test de récupération de l'historique..." -ForegroundColor Yellow
try {
    $historyResponse = Invoke-RestMethod -Uri "$BASE_URL/emotions/patient/1" `
        -Method Get `
        -Headers $headers
    
    Print-Result $true "Récupération de l'historique réussie"
} catch {
    Print-Result $false "Récupération de l'historique échouée"
    Write-Host "Erreur: $_" -ForegroundColor Red
}

Write-Host ""

# 7. Test de création de 3 émotions SAD pour déclencher une alerte
Write-Host "7. Test du système d'alerte (3 SAD consécutives)..." -ForegroundColor Yellow
$sadBody = @{
    emotionType = "SAD"
    confidence = 0.8
} | ConvertTo-Json

for ($i = 1; $i -le 3; $i++) {
    Write-Host "  Création de l'émotion SAD #$i..." -ForegroundColor Gray
    try {
        Invoke-RestMethod -Uri "$BASE_URL/emotions" `
            -Method Post `
            -ContentType "application/json" `
            -Headers $headers `
            -Body $sadBody | Out-Null
        Start-Sleep -Seconds 1
    } catch {
        Write-Host "  Erreur lors de la création: $_" -ForegroundColor Red
    }
}

Print-Result $true "3 émotions SAD créées (vérifiez les logs pour l'alerte)"
Write-Host ""

# 8. Test d'accès sans token (devrait échouer)
Write-Host "8. Test de sécurité (accès sans token)..." -ForegroundColor Yellow
try {
    Invoke-RestMethod -Uri "$BASE_URL/emotions" `
        -Method Get | Out-Null
    Print-Result $false "Sécurité: Accès autorisé sans token (non attendu)"
} catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 401) {
        Print-Result $true "Sécurité: Accès refusé sans token (attendu)"
    } else {
        Print-Result $false "Sécurité: Code d'erreur inattendu"
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Tests terminés!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Vérifiez les logs de l'application pour voir:" -ForegroundColor Yellow
Write-Host "  - Les requêtes SQL"
Write-Host "  - Les alertes créées"
Write-Host "  - Les erreurs éventuelles"

