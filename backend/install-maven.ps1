# Script PowerShell pour installer Maven automatiquement
# Ce script télécharge et configure Maven pour Windows

Write-Host "=== Installation de Maven ===" -ForegroundColor Green

# Vérifier si Maven est déjà installé
$mavenInstalled = Get-Command mvn -ErrorAction SilentlyContinue
if ($mavenInstalled) {
    Write-Host "Maven est déjà installé!" -ForegroundColor Yellow
    mvn -version
    exit 0
}

# Configuration
# Version Maven recommandée pour Spring Boot 3.2.0
$mavenVersion = "3.9.6"
$mavenUrl = "https://dlcdn.apache.org/maven/maven-3/$mavenVersion/binaries/apache-maven-$mavenVersion-bin.zip"
$installDir = "$env:ProgramFiles\Apache"
$mavenHome = "$installDir\apache-maven-$mavenVersion"

Write-Host "Téléchargement de Maven $mavenVersion..." -ForegroundColor Cyan

# Créer le répertoire d'installation
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

# Télécharger Maven
$zipFile = "$env:TEMP\apache-maven-$mavenVersion-bin.zip"
try {
    Invoke-WebRequest -Uri $mavenUrl -OutFile $zipFile -UseBasicParsing
    Write-Host "Téléchargement terminé!" -ForegroundColor Green
} catch {
    Write-Host "Erreur lors du téléchargement: $_" -ForegroundColor Red
    exit 1
}

# Extraire Maven
Write-Host "Extraction de Maven..." -ForegroundColor Cyan
Expand-Archive -Path $zipFile -DestinationPath $installDir -Force

# Ajouter Maven au PATH système
Write-Host "Configuration du PATH..." -ForegroundColor Cyan
$mavenBin = "$mavenHome\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")

if ($currentPath -notlike "*$mavenBin*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$mavenBin", "Machine")
    Write-Host "Maven ajouté au PATH système" -ForegroundColor Green
} else {
    Write-Host "Maven est déjà dans le PATH" -ForegroundColor Yellow
}

# Nettoyer
Remove-Item $zipFile -Force

Write-Host "`n=== Installation terminée! ===" -ForegroundColor Green
Write-Host "Veuillez redémarrer votre terminal PowerShell pour utiliser Maven." -ForegroundColor Yellow
Write-Host "Ou exécutez: refreshenv" -ForegroundColor Yellow
Write-Host "`nPour vérifier: mvn -version" -ForegroundColor Cyan

