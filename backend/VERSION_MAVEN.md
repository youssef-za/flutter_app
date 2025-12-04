# Version de Maven Requise

## 📋 Version Recommandée

Pour ce projet Spring Boot **3.2.0**, vous devez installer :

### **Maven 3.9.6** (Recommandé)

- **Version minimale requise** : Maven 3.5+
- **Version recommandée** : Maven 3.9.6 (dernière version stable)
- **Compatible avec** : Spring Boot 3.2.0 ✅

## 🔗 Téléchargement

### Lien Direct
```
https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip
```

### Page de Téléchargement
```
https://maven.apache.org/download.cgi
```

## 📥 Instructions d'Installation

### 1. Télécharger
- Aller sur : https://maven.apache.org/download.cgi
- Télécharger : **apache-maven-3.9.6-bin.zip**

### 2. Extraire
- Extraire dans : `C:\Program Files\Apache\maven`
- Résultat : `C:\Program Files\Apache\maven\apache-maven-3.9.6`

### 3. Configurer le PATH
- Ouvrir "Variables d'environnement"
- Dans "Variables système", modifier "Path"
- Ajouter : `C:\Program Files\Apache\maven\apache-maven-3.9.6\bin`

### 4. Vérifier
```powershell
mvn -version
```

Vous devriez voir :
```
Apache Maven 3.9.6
Maven home: C:\Program Files\Apache\maven\apache-maven-3.9.6
Java version: 23.0.2
```

## 🚀 Installation Automatique

Vous pouvez utiliser le script que j'ai créé :

```powershell
cd backend
.\install-maven.ps1
```

Ce script télécharge et installe automatiquement Maven 3.9.6.

## ✅ Compatibilité

| Composant | Version | Statut |
|-----------|---------|--------|
| Spring Boot | 3.2.0 | ✅ |
| Java | 23.0.2 | ✅ (Compatible) |
| Maven | 3.9.6 | ✅ (Recommandé) |
| Maven Minimum | 3.5+ | ✅ (Requis) |

## 📝 Notes

- **Maven 3.9.6** est la dernière version stable (Janvier 2024)
- Compatible avec **Spring Boot 3.2.0**
- Compatible avec **Java 17+** (vous avez Java 23 ✅)
- Supporte toutes les fonctionnalités modernes de Maven

## 🔄 Alternatives

Si vous ne pouvez pas installer Maven 3.9.6, ces versions fonctionneront aussi :
- Maven 3.8.x (minimum recommandé)
- Maven 3.6.x (minimum requis)
- Maven 3.5.x (minimum absolu)

Mais **Maven 3.9.6 est fortement recommandé** pour les meilleures performances et compatibilité.

