# Guide pour Exécuter le Backend Spring Boot

## Problème : Maven n'est pas installé

Si vous obtenez l'erreur `mvn : Le terme «mvn» n'est pas reconnu`, cela signifie que Maven n'est pas installé ou n'est pas dans le PATH.

## Solutions

### Solution 1 : Installer Maven (Recommandé)

#### Windows

1. **Télécharger Maven**
   - Aller sur https://maven.apache.org/download.cgi
   - Télécharger `apache-maven-3.9.x-bin.zip`

2. **Extraire et Configurer**
   - Extraire dans `C:\Program Files\Apache\maven`
   - Ajouter `C:\Program Files\Apache\maven\bin` au PATH système

3. **Vérifier l'installation**
   ```powershell
   mvn -version
   ```

4. **Exécuter le backend**
   ```powershell
   cd backend
   mvn spring-boot:run
   ```

#### Alternative : Utiliser Chocolatey

```powershell
choco install maven
```

### Solution 2 : Utiliser le Wrapper Maven (Sans Installation)

Si vous ne voulez pas installer Maven, vous pouvez utiliser le wrapper Maven.

#### Créer le Wrapper Maven

```powershell
cd backend
# Si vous avez Maven installé temporairement ou via IDE
mvn wrapper:wrapper
```

Puis exécuter :
```powershell
.\mvnw.cmd spring-boot:run
```

### Solution 3 : Utiliser un IDE (IntelliJ IDEA / Eclipse)

1. **Ouvrir le projet** dans IntelliJ IDEA ou Eclipse
2. **Importer comme projet Maven**
3. **Exécuter** `EmotionMonitoringApplication.java` directement

### Solution 4 : Compiler et Exécuter le JAR

Si vous avez déjà compilé le projet :

```powershell
cd backend
java -jar target/emotion-monitoring-1.0.0.jar
```

## Vérifications Préalables

### 1. Vérifier Java

```powershell
java -version
```

Vous devez avoir Java 17 ou supérieur.

### 2. Vérifier MySQL

Assurez-vous que MySQL est démarré et que la base de données existe.

### 3. Vérifier la Configuration

Vérifiez `src/main/resources/application.properties` :
- URL de la base de données
- Nom d'utilisateur MySQL
- Mot de passe MySQL

## Commandes Utiles

### Compiler le projet
```powershell
mvn clean compile
```

### Compiler et créer le JAR
```powershell
mvn clean package
```

### Exécuter les tests
```powershell
mvn test
```

### Exécuter l'application
```powershell
mvn spring-boot:run
```

### Exécuter le JAR compilé
```powershell
java -jar target/emotion-monitoring-1.0.0.jar
```

## Configuration de la Base de Données

Avant d'exécuter, assurez-vous que :

1. **MySQL est démarré** (via XAMPP ou service Windows)
2. **La base de données existe** :
   ```sql
   CREATE DATABASE emotion_monitoring;
   ```
3. **Les credentials sont corrects** dans `application.properties`

## Port par Défaut

L'application démarre sur le port **8080** par défaut.

Accès : `http://localhost:8080`

## Vérification du Démarrage

Une fois démarré, vous devriez voir :
```
Started EmotionMonitoringApplication in X.XXX seconds
```

Et vous pouvez tester avec :
```
http://localhost:8080/api/auth/register
```

## Dépannage

### Erreur : Port 8080 déjà utilisé
```powershell
# Changer le port dans application.properties
server.port=8081
```

### Erreur : Connexion MySQL échouée
- Vérifier que MySQL est démarré
- Vérifier les credentials dans `application.properties`
- Vérifier que la base de données existe

### Erreur : Java version incorrecte
- Installer Java 17 ou supérieur
- Vérifier JAVA_HOME

