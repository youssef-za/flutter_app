# Login Screen - Documentation

## ✅ Fonctionnalités Implémentées

### 1. **Champs Email et Password**
- ✅ Champ email avec validation
- ✅ Champ password avec masquage/affichage
- ✅ Validation en temps réel
- ✅ Messages d'erreur clairs

### 2. **Authentification HTTP POST avec Spring Boot**
- ✅ Appel POST à `/api/auth/login`
- ✅ Envoi des credentials (email, password)
- ✅ Gestion des erreurs réseau
- ✅ Gestion des erreurs d'authentification

### 3. **Stockage Sécurisé du Token JWT**
- ✅ Stockage dans `SharedPreferences`
- ✅ Token automatiquement ajouté aux requêtes suivantes
- ✅ Token chargé au démarrage de l'application
- ✅ Nettoyage automatique en cas d'erreur 401

### 4. **Design Professionnel et Propre**
- ✅ Interface moderne avec Material Design 3
- ✅ Card avec bordure subtile
- ✅ Icônes cohérentes
- ✅ Espacement harmonieux
- ✅ Animations de chargement
- ✅ Feedback visuel pour les erreurs

## 📋 Structure du Code

### LoginScreen (`lib/screens/auth/login_screen.dart`)

```dart
- Email field avec validation
- Password field avec toggle visibility
- Login button avec état de chargement
- Navigation vers Register
- Gestion des erreurs
```

### AuthProvider (`lib/providers/auth_provider.dart`)

```dart
- login(email, password) : Appel API et stockage token
- _saveAuth() : Sauvegarde token et user dans SharedPreferences
- _loadStoredAuth() : Charge token au démarrage
- Gestion des états (loading, error)
```

### ApiService (`lib/services/api_service.dart`)

```dart
- login(email, password) : POST /auth/login
- Intercepteur JWT : Ajoute automatiquement le token
- Gestion erreur 401 : Nettoie le token
```

## 🔐 Sécurité

### Stockage JWT
- Utilise `SharedPreferences` (stockage local sécurisé)
- Token stocké avec la clé `'token'` (configurable dans `AppConfig`)
- Token automatiquement ajouté dans le header `Authorization: Bearer {token}`

### Validation
- Email : Validation format avec `email_validator`
- Password : Minimum 6 caractères
- Validation côté client avant envoi

## 🎨 Design

### Éléments Visuels
- **Logo/Icon** : Cercle avec icône dans un container coloré
- **Card** : Container avec bordure subtile et padding généreux
- **Champs** : OutlineInputBorder avec focus coloré
- **Bouton** : Primary color avec icône et état de chargement
- **Couleurs** : Utilise le thème Material Design 3

### Responsive
- SingleChildScrollView pour les petits écrans
- Padding adaptatif
- SafeArea pour éviter les zones système

## 🚀 Utilisation

```dart
// Navigation vers Login
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const LoginScreen()),
);

// Ou via route nommée
Navigator.pushNamed(context, AppRoutes.login);
```

## 📝 Notes

- Le token JWT est automatiquement géré par `ApiService`
- Les erreurs sont affichées via `SnackBar`
- Le chargement est géré par `AuthProvider.isLoading`
- Après connexion réussie, redirection vers `HomeScreen`

