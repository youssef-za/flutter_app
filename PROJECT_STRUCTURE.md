# Structure du Projet

## 📁 Organisation

Le projet est organisé en deux parties distinctes :

```
emotion_monitoring/
├── backend/          # Backend Spring Boot
│   ├── src/          # Code source Java
│   ├── pom.xml       # Configuration Maven
│   ├── Dockerfile    # Configuration Docker
│   ├── README.md     # Documentation backend
│   └── ...
│
├── frontend/         # Frontend Flutter
│   ├── lib/          # Code source Dart
│   ├── pubspec.yaml  # Configuration Flutter
│   ├── README.md     # Documentation frontend
│   └── ...
│
└── README.md         # Documentation principale
```

## 🎯 Avantages de cette Structure

1. **Séparation claire** : Backend et frontend sont complètement séparés
2. **Déploiement indépendant** : Chaque partie peut être déployée séparément
3. **Gestion de versions** : Facilite la gestion Git avec des branches séparées
4. **Équipes** : Permet à différentes équipes de travailler en parallèle
5. **Maintenance** : Plus facile de maintenir et comprendre le projet

## 🚀 Commandes Rapides

### Backend
```bash
cd backend
mvn spring-boot:run
```

### Frontend
```bash
cd frontend
flutter pub get
flutter run
```

## 📚 Documentation

- **Racine** : `README.md` - Vue d'ensemble du projet
- **Backend** : `backend/README.md` - Documentation backend
- **Frontend** : `frontend/README.md` - Documentation frontend

## 🔧 Configuration

### Backend
- Port par défaut : `8080`
- Base de données : MySQL (`emotion_monitoring`)
- Configuration : `backend/src/main/resources/application.properties`

### Frontend
- URL backend : `http://localhost:8080/api`
- Configuration : `frontend/lib/config/app_config.dart`

