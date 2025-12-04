# Medical Emotion Monitoring System

Système complet de monitoring d'émotions médicales avec backend Spring Boot et frontend Flutter.

## 📁 Structure du Projet

```
emotion_monitoring/
├── backend/          # Backend Spring Boot
│   ├── src/          # Code source Java
│   ├── pom.xml       # Configuration Maven
│   ├── Dockerfile    # Configuration Docker
│   └── README.md     # Documentation backend
│
├── frontend/         # Frontend Flutter
│   ├── lib/          # Code source Dart
│   ├── pubspec.yaml  # Configuration Flutter
│   └── README.md     # Documentation frontend
│
└── README.md         # Ce fichier
```

## 🚀 Démarrage Rapide

### Backend (Spring Boot)

```bash
cd backend
mvn spring-boot:run
```

Le backend sera disponible sur `http://localhost:8080/api`

### Frontend (Flutter)

```bash
cd frontend
flutter pub get
flutter run
```

## 📚 Documentation

- **Backend**: Voir `backend/README.md`
- **Frontend**: Voir `frontend/README.md`
- **Structure**: Voir `PROJECT_STRUCTURE.md`

## 🛠️ Technologies

### Backend
- Spring Boot 3.2.0
- MySQL
- JWT Authentication
- Spring Security

### Frontend
- Flutter 3.38.3
- Provider (State Management)
- Dio (HTTP Client)

## 📝 Notes

- Assurez-vous que MySQL est démarré avant de lancer le backend
- Le frontend se connecte par défaut à `http://localhost:8080/api`
- Pour changer l'URL du backend, modifiez `frontend/lib/config/app_config.dart`

## 🎯 Fonctionnalités

- ✅ Authentification JWT (Login/Register)
- ✅ Enregistrement d'émotions
- ✅ Détection d'émotion depuis une image
- ✅ Historique des émotions
- ✅ Système d'alertes automatiques
- ✅ Interface utilisateur moderne
