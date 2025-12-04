# Exécuter le Backend avec mvnd (Maven Daemon)

## ✅ Compatibilité Confirmée

**Maven Daemon (mvnd) 1.0.3** est **100% compatible** avec votre projet !

### Informations

- **Type** : Maven Daemon (version améliorée de Maven)
- **Version Maven incluse** : **Maven 3.9.11** ✅
- **Compatible avec** : Spring Boot 3.2.0 ✅
- **Avantage** : ⚡ Plus rapide que Maven standard

## 🚀 Exécution Rapide

### Méthode 1 : Configuration Automatique (Recommandé)

```powershell
cd C:\Users\Dell\Desktop\flutter_app\backend
.\configure-mvnd.ps1
```

Puis exécuter :
```powershell
mvnd spring-boot:run
```

### Méthode 2 : Configuration Manuelle

```powershell
# Ajouter mvnd au PATH de la session
$mvndPath = "C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\bin"
$env:Path += ";$mvndPath"

# Vérifier
mvnd -version

# Exécuter le backend
cd C:\Users\Dell\Desktop\flutter_app\backend
mvnd spring-boot:run
```

### Méthode 3 : Utiliser le Chemin Complet

```powershell
cd C:\Users\Dell\Desktop\flutter_app\backend
& "C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\bin\mvnd.exe" spring-boot:run
```

## 🔧 Configuration Permanente du PATH

### Via Interface Graphique

1. Ouvrir "Variables d'environnement"
2. Modifier "Path" dans "Variables système"
3. Ajouter :
   ```
   C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\bin
   ```
4. Redémarrer PowerShell

### Via PowerShell (Administrateur)

```powershell
$mvndPath = "C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
[Environment]::SetEnvironmentVariable("Path", "$currentPath;$mvndPath", "Machine")
```

## ✅ Vérification

Après configuration, vérifiez :

```powershell
mvnd -version
```

Vous devriez voir :
```
Apache Maven Daemon (mvnd) 1.0.3
Apache Maven 3.9.11
Java version: 23.0.2
```

## 🎯 Commandes Utiles avec mvnd

### Compiler le projet
```powershell
mvnd clean compile
```

### Créer le JAR
```powershell
mvnd clean package
```

### Exécuter l'application
```powershell
mvnd spring-boot:run
```

### Exécuter les tests
```powershell
mvnd test
```

## 📊 Avantages de mvnd

1. **⚡ Plus rapide** : Le daemon garde Maven en mémoire
2. **✅ Compatible** : Utilise les mêmes commandes que Maven
3. **📦 Maven 3.9.11** : Version récente et compatible
4. **🔧 Déjà installé** : Pas besoin d'installer autre chose

## 🔄 Commandes Équivalentes

| Maven Standard | mvnd |
|---------------|------|
| `mvn clean` | `mvnd clean` |
| `mvn compile` | `mvnd compile` |
| `mvn package` | `mvnd package` |
| `mvn spring-boot:run` | `mvnd spring-boot:run` |
| `mvn test` | `mvnd test` |

## 🌐 Accès à l'Application

Une fois démarré, l'application sera disponible sur :
- **URL Base** : `http://localhost:8080`
- **API Base** : `http://localhost:8080/api`

## ✨ Conclusion

**Vous pouvez utiliser mvnd 1.0.3 directement !** 

C'est même **mieux** que Maven standard car :
- ✅ Plus rapide
- ✅ Maven 3.9.11 (plus récent que 3.9.6)
- ✅ Déjà installé sur votre système
- ✅ 100% compatible avec Spring Boot 3.2.0

Il vous suffit d'ajouter le chemin au PATH et d'utiliser `mvnd` au lieu de `mvn`.

