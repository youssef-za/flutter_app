# Guide pour Exécuter le Backend

## ⚠️ Problème : Maven n'est pas installé

Maven n'est pas installé sur votre système. Voici plusieurs solutions :

## 🚀 Solution 1 : Installer Maven (Recommandé)

### Option A : Installation Automatique avec Script

1. **Exécuter le script d'installation** :
   ```powershell
   cd backend
   .\install-maven.ps1
   ```

2. **Redémarrer PowerShell** ou exécuter :
   ```powershell
   refreshenv
   ```

3. **Vérifier l'installation** :
   ```powershell
   mvn -version
   ```

4. **Exécuter le backend** :
   ```powershell
   .\run-backend.ps1
   ```
   Ou directement :
   ```powershell
   mvn spring-boot:run
   ```

### Option B : Installation Manuelle

1. **Télécharger Maven** :
   - Aller sur : https://maven.apache.org/download.cgi
   - Télécharger : `apache-maven-3.9.6-bin.zip`

2. **Extraire** :
   - Extraire dans : `C:\Program Files\Apache\maven`

3. **Ajouter au PATH** :
   - Ouvrir "Variables d'environnement"
   - Ajouter : `C:\Program Files\Apache\maven\bin` au PATH système

4. **Vérifier** :
   ```powershell
   mvn -version
   ```

### Option C : Utiliser Chocolatey (si installé)

```powershell
choco install maven
```

## 🚀 Solution 2 : Utiliser un IDE

### IntelliJ IDEA

1. **Ouvrir le projet** :
   - File → Open → Sélectionner le dossier `backend`

2. **Importer comme projet Maven** :
   - IntelliJ détectera automatiquement `pom.xml`

3. **Exécuter** :
   - Ouvrir `src/main/java/com/medical/emotionmonitoring/EmotionMonitoringApplication.java`
   - Cliquer sur le bouton "Run" (▶️)

### Eclipse

1. **Ouvrir le projet** :
   - File → Import → Maven → Existing Maven Projects
   - Sélectionner le dossier `backend`

2. **Exécuter** :
   - Clic droit sur `EmotionMonitoringApplication.java`
   - Run As → Java Application

## 🚀 Solution 3 : Utiliser le Script Automatique

J'ai créé un script qui vérifie tout et exécute l'application :

```powershell
cd backend
.\run-backend.ps1
```

Ce script :
- ✅ Vérifie Java
- ✅ Vérifie Maven
- ✅ Vérifie la configuration
- ✅ Démarre l'application

## 📋 Prérequis

Avant d'exécuter, assurez-vous que :

1. **Java 17+ est installé** ✅ (Vous avez Java 23)
   ```powershell
   java -version
   ```

2. **MySQL est démarré** :
   - Via XAMPP : Démarrer MySQL
   - Ou service Windows MySQL

3. **Base de données créée** :
   ```sql
   CREATE DATABASE emotion_monitoring;
   ```

4. **Configuration correcte** :
   - Vérifier `src/main/resources/application.properties`
   - Username et password MySQL

## 🔧 Commandes Utiles

### Compiler le projet
```powershell
mvn clean compile
```

### Créer le JAR
```powershell
mvn clean package
```

### Exécuter l'application
```powershell
mvn spring-boot:run
```

### Exécuter le JAR compilé
```powershell
java -jar target/emotion-monitoring-1.0.0.jar
```

## 🌐 Accès à l'Application

Une fois démarré, l'application sera disponible sur :
- **URL Base** : `http://localhost:8080`
- **API Base** : `http://localhost:8080/api`

### Endpoints Principaux

- **Register** : `POST http://localhost:8080/api/auth/register`
- **Login** : `POST http://localhost:8080/api/auth/login`
- **Validate Token** : `GET http://localhost:8080/api/auth/validate`

## 🐛 Dépannage

### Erreur : Port 8080 déjà utilisé

Changer le port dans `application.properties` :
```properties
server.port=8081
```

### Erreur : Connexion MySQL échouée

1. Vérifier que MySQL est démarré
2. Vérifier les credentials dans `application.properties`
3. Vérifier que la base de données existe :
   ```sql
   SHOW DATABASES;
   ```

### Erreur : Maven non trouvé

- Installer Maven (voir Solution 1)
- Ou utiliser un IDE (voir Solution 2)

## 📝 Notes

- L'application démarre généralement en 10-30 secondes
- Vous verrez "Started EmotionMonitoringApplication" quand c'est prêt
- Appuyez sur `Ctrl+C` pour arrêter l'application

