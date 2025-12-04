# Script pour configurer mvnd (Maven Daemon) pour ce projet
# Ce script ajoute mvnd au PATH et vérifie l'installation

Write-Host "=== Configuration de Maven Daemon (mvnd) ===" -ForegroundColor Green

# Chemin vers mvnd
$mvndPath = "C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\bin"
$mvnPath = "C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\mvn\bin"

# Vérifier si le chemin existe
if (-not (Test-Path $mvndPath)) {
    Write-Host "❌ Chemin mvnd non trouvé: $mvndPath" -ForegroundColor Red
    Write-Host "Veuillez vérifier le chemin d'installation de mvnd" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Chemin mvnd trouvé: $mvndPath" -ForegroundColor Green

# Ajouter au PATH de la session actuelle
$env:Path += ";$mvndPath;$mvnPath"
Write-Host "✅ mvnd ajouté au PATH de la session actuelle" -ForegroundColor Green

# Vérifier l'installation
Write-Host "`nVérification de l'installation..." -ForegroundColor Cyan

try {
    $mvndVersion = & "$mvndPath\mvnd.exe" -version 2>&1
    Write-Host "✅ mvnd fonctionne correctement!" -ForegroundColor Green
    Write-Host $mvndVersion
} catch {
    Write-Host "❌ Erreur lors de la vérification: $_" -ForegroundColor Red
    exit 1
}

# Option: Ajouter au PATH système (nécessite droits admin)
Write-Host "`n=== Configuration du PATH Système ===" -ForegroundColor Cyan
$addToSystemPath = Read-Host "Voulez-vous ajouter mvnd au PATH système de manière permanente? (O/N)"

if ($addToSystemPath -eq "O" -or $addToSystemPath -eq "o") {
    try {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        
        if ($currentPath -notlike "*$mvndPath*") {
            [Environment]::SetEnvironmentVariable("Path", "$currentPath;$mvndPath;$mvnPath", "Machine")
            Write-Host "✅ mvnd ajouté au PATH système" -ForegroundColor Green
            Write-Host "⚠️  Redémarrez PowerShell pour que les changements prennent effet" -ForegroundColor Yellow
        } else {
            Write-Host "✅ mvnd est déjà dans le PATH système" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "❌ Erreur: Vous devez exécuter ce script en tant qu'administrateur" -ForegroundColor Red
        Write-Host "Ou ajoutez manuellement au PATH: $mvndPath" -ForegroundColor Yellow
    }
} else {
    Write-Host "ℹ️  mvnd est disponible uniquement dans cette session PowerShell" -ForegroundColor Yellow
    Write-Host "Pour l'ajouter de manière permanente, exécutez ce script en tant qu'administrateur" -ForegroundColor Yellow
}

Write-Host "`n=== Configuration terminée! ===" -ForegroundColor Green
Write-Host "`nPour exécuter le backend:" -ForegroundColor Cyan
Write-Host "  cd C:\Users\Dell\Desktop\flutter_app\backend" -ForegroundColor White
Write-Host "  mvnd spring-boot:run" -ForegroundColor White
Write-Host "`nOu avec mvn standard:" -ForegroundColor Cyan
Write-Host "  mvn spring-boot:run" -ForegroundColor White

