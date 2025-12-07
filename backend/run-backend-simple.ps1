# Script simple pour exécuter le backend Spring Boot
# Ce script configure mvnd et exécute le backend

Write-Host "=== Démarrage du Backend Spring Boot ===" -ForegroundColor Green

# Vérifier que nous sommes dans le bon répertoire
$currentDir = Get-Location
if (-not (Test-Path "pom.xml")) {
    Write-Host "❌ Erreur: pom.xml non trouvé!" -ForegroundColor Red
    Write-Host "Veuillez exécuter ce script depuis le répertoire backend" -ForegroundColor Yellow
    Write-Host "Répertoire actuel: $currentDir" -ForegroundColor Yellow
    exit 1
}

# Ajouter mvnd au PATH
$mvndPath = "C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\bin"
if (Test-Path $mvndPath) {
    $env:Path += ";$mvndPath"
    Write-Host "✅ mvnd ajouté au PATH" -ForegroundColor Green
} else {
    Write-Host "⚠️  mvnd non trouvé, utilisation de mvn standard" -ForegroundColor Yellow
}

# Vérifier Java
Write-Host "`nVérification de Java..." -ForegroundColor Cyan
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "✅ $javaVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Java non trouvé!" -ForegroundColor Red
    exit 1
}

# Vérifier Maven/mvnd
Write-Host "`nVérification de Maven/mvnd..." -ForegroundColor Cyan
try {
    if (Get-Command mvnd -ErrorAction SilentlyContinue) {
        $mavenVersion = mvnd -version 2>&1 | Select-Object -First 3
        Write-Host "✅ Utilisation de mvnd (Maven Daemon)" -ForegroundColor Green
        $mavenCmd = "mvnd"
    } elseif (Get-Command mvn -ErrorAction SilentlyContinue) {
        $mavenVersion = mvn -version 2>&1 | Select-Object -First 1
        Write-Host "✅ Utilisation de mvn standard" -ForegroundColor Green
        $mavenCmd = "mvn"
    } else {
        Write-Host "❌ Maven/mvnd non trouvé!" -ForegroundColor Red
        Write-Host "Veuillez installer Maven ou configurer mvnd" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "❌ Erreur lors de la vérification de Maven" -ForegroundColor Red
    exit 1
}

# Afficher les informations
Write-Host "`n=== Informations du Projet ===" -ForegroundColor Cyan
Write-Host "Répertoire: $currentDir" -ForegroundColor White
Write-Host "Commande Maven: $mavenCmd" -ForegroundColor White
Write-Host "`nL'application sera disponible sur: http://localhost:8080" -ForegroundColor Yellow
Write-Host "Appuyez sur Ctrl+C pour arrêter`n" -ForegroundColor Yellow

# Exécuter le backend
Write-Host "=== Démarrage de l'application ===" -ForegroundColor Green
& $mavenCmd spring-boot:run


