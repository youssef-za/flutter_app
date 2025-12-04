# Architecture du Projet Flutter

## 📁 Structure des Dossiers

```
lib/
├── main.dart                 # Point d'entrée de l'application
│
├── config/                   # Configuration de l'application
│   ├── app_config.dart       # Configuration générale (URLs, timeouts, clés)
│   ├── app_routes.dart       # Définition des routes
│   └── app_theme.dart        # Thème de l'application
│
├── models/                   # Modèles de données
│   ├── user_model.dart       # Modèle utilisateur
│   ├── emotion_model.dart    # Modèle émotion
│   └── auth_response_model.dart # Modèle réponse authentification
│
├── providers/                # State Management (Provider)
│   ├── auth_provider.dart    # Gestion de l'authentification
│   └── emotion_provider.dart  # Gestion des émotions
│
├── screens/                  # Écrans de l'application
│   ├── splash_screen.dart    # Écran de démarrage
│   ├── auth/
│   │   ├── login_screen.dart      # Écran de connexion
│   │   └── register_screen.dart   # Écran d'inscription
│   └── home/
│       ├── home_screen.dart       # Écran principal
│       └── tabs/
│           ├── emotions_tab.dart  # Onglet émotions
│           ├── history_tab.dart   # Onglet historique
│           └── profile_tab.dart    # Onglet profil
│
├── services/                 # Services API et logique métier
│   └── api_service.dart      # Service de communication avec le backend
│
└── widgets/                  # Widgets réutilisables
    ├── loading_widget.dart       # Widget de chargement
    ├── error_widget.dart          # Widget d'erreur
    ├── empty_state_widget.dart    # Widget état vide
    ├── emotion_card.dart          # Carte d'émotion
    ├── custom_text_field.dart     # Champ de texte personnalisé
    ├── custom_button.dart         # Bouton personnalisé
    └── index.dart                 # Exports des widgets
```

## 🏗️ Architecture

### 1. **Config** (`lib/config/`)
Contient toute la configuration de l'application:
- `app_config.dart`: URLs, timeouts, clés de stockage
- `app_routes.dart`: Définition centralisée des routes
- `app_theme.dart`: Thème et couleurs de l'application

### 2. **Models** (`lib/models/`)
Modèles de données correspondant aux entités du backend:
- Utilisation de `fromJson()` et `toJson()` pour la sérialisation
- Types sûrs avec null-safety

### 3. **Providers** (`lib/providers/`)
Gestion d'état avec Provider:
- `AuthProvider`: Authentification, login, register, logout
- `EmotionProvider`: Création, récupération, historique des émotions
- Utilisation de `ChangeNotifier` pour notifier les changements

### 4. **Screens** (`lib/screens/`)
Écrans de l'application organisés par fonctionnalité:
- `auth/`: Écrans d'authentification
- `home/`: Écran principal avec onglets
- Navigation via routes nommées

### 5. **Services** (`lib/services/`)
Services pour la communication avec le backend:
- `ApiService`: Client HTTP avec Dio, gestion JWT automatique
- Intercepteurs pour ajouter le token JWT
- Gestion des erreurs centralisée

### 6. **Widgets** (`lib/widgets/`)
Widgets réutilisables:
- `LoadingWidget`: Indicateur de chargement
- `ErrorDisplayWidget`: Affichage d'erreur avec retry
- `EmptyStateWidget`: État vide avec message
- `EmotionCard`: Carte pour afficher une émotion
- `CustomTextField`: Champ de texte personnalisé
- `CustomButton`: Bouton personnalisé avec loading

## 🔄 Flux de Données

```
User Action
    ↓
Screen (UI)
    ↓
Provider (State Management)
    ↓
Service (API Call)
    ↓
Backend (Spring Boot)
    ↓
Response
    ↓
Provider (Update State)
    ↓
Screen (Rebuild UI)
```

## 📦 Dépendances Principales

- **provider**: Gestion d'état
- **dio**: Client HTTP
- **shared_preferences**: Stockage local
- **image_picker**: Sélection d'images
- **intl**: Formatage de dates
- **email_validator**: Validation d'email

## 🎯 Bonnes Pratiques

1. **Séparation des responsabilités**: Chaque dossier a un rôle clair
2. **Réutilisabilité**: Widgets dans `widgets/` pour éviter la duplication
3. **Configuration centralisée**: Tous les paramètres dans `config/`
4. **Type safety**: Utilisation de modèles typés
5. **Error handling**: Gestion d'erreurs dans les providers
6. **Loading states**: États de chargement gérés dans les providers

## 🚀 Ajout de Nouvelles Fonctionnalités

### Ajouter un nouvel écran:
1. Créer le fichier dans `screens/`
2. Ajouter la route dans `app_routes.dart`
3. Enregistrer la route dans `main.dart`

### Ajouter un nouveau provider:
1. Créer le fichier dans `providers/`
2. Étendre `ChangeNotifier`
3. Enregistrer dans `main.dart` avec `ChangeNotifierProvider`

### Ajouter un nouveau service:
1. Créer le fichier dans `services/`
2. Utiliser `ApiService` ou créer un nouveau service
3. Injecter dans les providers qui en ont besoin

### Ajouter un widget réutilisable:
1. Créer le fichier dans `widgets/`
2. Exporter dans `widgets/index.dart`
3. Utiliser dans les écrans

## 📝 Notes

- Tous les imports utilisent des chemins relatifs
- Les widgets sont stateless quand possible
- Les providers gèrent les états de chargement et d'erreur
- La configuration est centralisée pour faciliter les changements

