# Script PowerShell pour exécuter le backend Spring Boot
# Ce script vérifie les prérequis et exécute l'application

Write-Host "=== Démarrage du Backend Spring Boot ===" -ForegroundColor Green

# Vérifier Java
Write-Host "Vérification de Java..." -ForegroundColor Cyan
$javaVersion = java -version 2>&1 | Select-String "version"
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Java n'est pas installé ou n'est pas dans le PATH" -ForegroundColor Red
    Write-Host "Veuillez installer Java 17 ou supérieur" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ Java trouvé: $javaVersion" -ForegroundColor Green

# Vérifier Maven
Write-Host "`nVérification de Maven..." -ForegroundColor Cyan
$mavenInstalled = Get-Command mvn -ErrorAction SilentlyContinue
if (-not $mavenInstalled) {
    Write-Host "❌ Maven n'est pas installé" -ForegroundColor Red
    Write-Host "Options:" -ForegroundColor Yellow
    Write-Host "1. Installer Maven manuellement: https://maven.apache.org/download.cgi" -ForegroundColor Yellow
    Write-Host "2. Exécuter: .\install-maven.ps1" -ForegroundColor Yellow
    Write-Host "3. Utiliser un IDE (IntelliJ IDEA / Eclipse)" -ForegroundColor Yellow
    exit 1
}
Write-Host "✅ Maven trouvé" -ForegroundColor Green
mvn -version

# Vérifier la base de données
Write-Host "`n⚠️  Assurez-vous que MySQL est démarré et que la base de données 'emotion_monitoring' existe" -ForegroundColor Yellow

# Vérifier la configuration
$configFile = "src\main\resources\application.properties"
if (-not (Test-Path $configFile)) {
    Write-Host "❌ Fichier de configuration non trouvé: $configFile" -ForegroundColor Red
    exit 1
}
Write-Host "✅ Fichier de configuration trouvé" -ForegroundColor Green

# Exécuter l'application
Write-Host "`n=== Démarrage de l'application ===" -ForegroundColor Green
Write-Host "L'application sera disponible sur: http://localhost:8080" -ForegroundColor Cyan
Write-Host "Appuyez sur Ctrl+C pour arrêter l'application`n" -ForegroundColor Yellow

try {
    mvn spring-boot:run
} catch {
    Write-Host "`n❌ Erreur lors du démarrage: $_" -ForegroundColor Red
    exit 1
}

