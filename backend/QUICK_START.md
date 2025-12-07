# 🚀 Démarrage Rapide du Backend

## ⚠️ Problème Courant

Si vous obtenez l'erreur :
```
[ERROR] No plugin found for prefix 'spring-boot'
```

**C'est parce que vous n'êtes pas dans le bon répertoire !**

## ✅ Solution

### Option 1 : Utiliser Git Bash (Recommandé)

```bash
cd ~/Desktop/flutter_app/backend
./run-backend.sh
```

### Option 2 : Utiliser PowerShell

```powershell
cd C:\Users\Dell\Desktop\flutter_app\backend
.\run-backend-simple.ps1
```

### Option 3 : Commande Manuelle

**Avec Git Bash :**
```bash
cd ~/Desktop/flutter_app/backend
export PATH="$PATH:/c/Users/Dell/Desktop/maven-mvnd-1.0.3-windows-amd64/maven-mvnd-1.0.3-windows-amd64/bin"
mvnd spring-boot:run
```

**Avec PowerShell :**
```powershell
cd C:\Users\Dell\Desktop\flutter_app\backend
$mvndPath = "C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\bin"
$env:Path += ";$mvndPath"
mvnd spring-boot:run
```

## 📍 Important

**Le `pom.xml` doit être dans le répertoire courant !**

- ✅ **Correct** : `~/Desktop/flutter_app/backend/` (où se trouve `pom.xml`)
- ❌ **Incorrect** : `~/Desktop/flutter_app/` (répertoire racine)

## 🔍 Vérification

Avant d'exécuter, vérifiez que vous êtes dans le bon répertoire :

```bash
# Git Bash
pwd
ls pom.xml

# PowerShell
Get-Location
Test-Path pom.xml
```

Si `pom.xml` n'existe pas, vous n'êtes pas dans le bon répertoire !

## 🌐 Accès à l'Application

Une fois démarré, l'application sera disponible sur :
- **URL Base** : `http://localhost:8080`
- **API Base** : `http://localhost:8080/api`

## 🛑 Arrêter l'Application

Appuyez sur `Ctrl+C` dans le terminal où l'application tourne.


