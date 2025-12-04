# Flutter Frontend - Medical Emotion Monitoring

Application Flutter pour le système de monitoring d'émotions médicales.

## Prérequis

- Flutter SDK 3.38.3-stable ou supérieur
- Dart SDK 3.0.0 ou supérieur
- Android Studio / VS Code avec extensions Flutter
- Backend Spring Boot en cours d'exécution sur `http://localhost:8080/api`

## Installation

1. **Installer les dépendances:**
   ```bash
   flutter pub get
   ```

2. **Vérifier la configuration:**
   - Le backend doit être démarré sur `http://localhost:8080/api`
   - Pour changer l'URL, modifiez `lib/services/api_service.dart`

3. **Lancer l'application:**
   ```bash
   flutter run
   ```

## Structure du Projet

```
lib/
├── main.dart                 # Point d'entrée
├── models/                   # Modèles de données
│   ├── user_model.dart
│   ├── emotion_model.dart
│   └── auth_response_model.dart
├── providers/                # State Management (Provider)
│   ├── auth_provider.dart
│   └── emotion_provider.dart
├── screens/                  # Écrans de l'application
│   ├── splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   └── home/
│       ├── home_screen.dart
│       └── tabs/
│           ├── emotions_tab.dart
│           ├── history_tab.dart
│           └── profile_tab.dart
└── services/                 # Services API
    └── api_service.dart
```

## Fonctionnalités

### Authentification
- ✅ Inscription (Register)
- ✅ Connexion (Login)
- ✅ Gestion du token JWT
- ✅ Déconnexion

### Gestion des Émotions
- ✅ Création manuelle d'émotion
- ✅ Détection d'émotion depuis une image (caméra)
- ✅ Affichage de l'historique des émotions
- ✅ Affichage de la dernière émotion enregistrée

### Interface Utilisateur
- ✅ Design moderne avec Material Design 3
- ✅ Navigation par onglets
- ✅ Validation des formulaires
- ✅ Gestion des erreurs
- ✅ Indicateurs de chargement

## Configuration

### Changer l'URL du Backend

Modifiez `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://VOTRE_IP:8080/api';
```

Pour tester sur un appareil physique:
```dart
static const String baseUrl = 'http://192.168.1.X:8080/api';
```

## Utilisation

1. **Démarrer le backend Spring Boot**
2. **Lancer l'application Flutter**
3. **S'inscrire** avec un nouveau compte
4. **Se connecter** avec vos identifiants
5. **Enregistrer des émotions** manuellement ou via la caméra
6. **Consulter l'historique** dans l'onglet History

## Dépendances Principales

- `provider` - State management
- `dio` - Client HTTP
- `shared_preferences` - Stockage local
- `image_picker` - Sélection d'images
- `email_validator` - Validation d'email
- `intl` - Formatage de dates

## Compatibilité

- ✅ Flutter 3.38.3-stable
- ✅ Dart 3.0.0+
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows (avec configuration)

## Prochaines Étapes

Pour ajouter plus de fonctionnalités:
- Graphiques d'émotions (fl_chart)
- Notifications push
- Mode sombre
- Export des données
- Statistiques avancées

