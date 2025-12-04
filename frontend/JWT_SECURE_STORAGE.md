# JWT Secure Storage & Auto-Login - Documentation

## ✅ Fonctionnalités Implémentées

### 1. **Stockage Sécurisé du JWT Token**
- ✅ Utilisation de `flutter_secure_storage` pour le stockage sécurisé
- ✅ Chiffrement des données sur Android (EncryptedSharedPreferences)
- ✅ Utilisation du Keychain sur iOS
- ✅ Stockage sécurisé du token et des données utilisateur
- ✅ Méthodes pour sauvegarder, récupérer et supprimer les données

### 2. **Service de Stockage Sécurisé**
- ✅ Classe `SecureStorageService` centralisée
- ✅ Méthodes pour token : `saveToken()`, `getToken()`, `deleteToken()`
- ✅ Méthodes pour utilisateur : `saveUser()`, `getUser()`, `deleteUser()`
- ✅ Méthode `clearAll()` pour tout supprimer
- ✅ Méthodes de vérification : `hasToken()`, `hasUser()`

### 3. **Système d'Auto-Login**
- ✅ Chargement automatique du token au démarrage
- ✅ Validation du token avec le backend
- ✅ Navigation automatique vers HomeScreen si authentifié
- ✅ Navigation vers LoginScreen si non authentifié
- ✅ Gestion des erreurs de validation

### 4. **Gestion de l'Authentification**
- ✅ État d'initialisation (`isInitializing`)
- ✅ Méthode `autoLogin()` pour l'authentification automatique
- ✅ Méthode `validateToken()` pour valider le token
- ✅ Déconnexion automatique si token invalide
- ✅ Mise à jour de `AuthProvider` pour utiliser le stockage sécurisé

### 5. **Intégration avec ApiService**
- ✅ Mise à jour de `ApiService` pour utiliser `SecureStorageService`
- ✅ Attachement automatique du token depuis le stockage sécurisé
- ✅ Nettoyage automatique en cas d'erreur 401

## 📋 Structure du Code

### SecureStorageService (`lib/services/secure_storage_service.dart`)

```dart
- saveToken(String token): Sauvegarder le token
- getToken(): Récupérer le token
- deleteToken(): Supprimer le token
- saveUser(Map<String, dynamic>): Sauvegarder les données utilisateur
- getUser(): Récupérer les données utilisateur
- deleteUser(): Supprimer les données utilisateur
- clearAll(): Supprimer toutes les données
- hasToken(): Vérifier si token existe
- hasUser(): Vérifier si utilisateur existe
```

### AuthProvider (`lib/providers/auth_provider.dart`)

```dart
- _initialize(): Initialisation et chargement du token
- _loadStoredAuth(): Charger l'authentification depuis le stockage
- validateToken(): Valider le token avec le backend
- autoLogin(): Auto-login avec validation
- register(): Inscription (utilise stockage sécurisé)
- login(): Connexion (utilise stockage sécurisé)
- logout(): Déconnexion (supprime tout)
```

### SplashScreen (`lib/screens/splash_screen.dart`)

```dart
- _initializeApp(): Initialisation de l'app
- Attente de l'initialisation du AuthProvider
- Appel de autoLogin()
- Navigation basée sur l'état d'authentification
```

## 🔐 Sécurité

### Stockage Sécurisé

#### Android
- Utilise `EncryptedSharedPreferences`
- Chiffrement AES-256
- Stockage dans le système de fichiers sécurisé

#### iOS
- Utilise `Keychain`
- Accessibilité : `first_unlock_this_device`
- Protection par mot de passe/biométrie

### Protection des Données

1. **Token JWT**
   - Stocké de manière sécurisée
   - Non accessible par d'autres apps
   - Supprimé automatiquement en cas d'erreur 401

2. **Données Utilisateur**
   - Stockées en JSON chiffré
   - Incluent : id, fullName, email, role
   - Supprimées lors de la déconnexion

## 🔄 Flux d'Auto-Login

### 1. Démarrage de l'Application
```
SplashScreen → _initializeApp()
```

### 2. Initialisation du AuthProvider
```
AuthProvider() → _initialize() → _loadStoredAuth()
```

### 3. Chargement du Token
```
SecureStorageService.getToken() → Token récupéré
SecureStorageService.getUser() → User récupéré
```

### 4. Validation du Token
```
autoLogin() → validateToken() → API /auth/validate
```

### 5. Navigation
```
Si token valide → HomeScreen
Si token invalide → LoginScreen
```

## 🎯 Utilisation

### Auto-Login Automatique

L'auto-login se fait automatiquement au démarrage de l'application via `SplashScreen` :

```dart
// Dans SplashScreen
final isAuthenticated = await authProvider.autoLogin();

if (isAuthenticated) {
  // Navigate to HomeScreen
} else {
  // Navigate to LoginScreen
}
```

### Validation Manuelle du Token

```dart
final authProvider = Provider.of<AuthProvider>(context, listen: false);
final isValid = await authProvider.validateToken();

if (!isValid) {
  // Token is invalid, user needs to login again
  await authProvider.logout();
}
```

### Vérification de l'État d'Authentification

```dart
final authProvider = Provider.of<AuthProvider>(context);

if (authProvider.isAuthenticated) {
  // User is authenticated
  final user = authProvider.currentUser;
  final token = authProvider.token;
} else {
  // User is not authenticated
}
```

### Attente de l'Initialisation

```dart
// Wait for initialization
while (authProvider.isInitializing) {
  await Future.delayed(const Duration(milliseconds: 100));
}

// Now safe to check authentication
if (authProvider.isAuthenticated) {
  // ...
}
```

## 📝 Migration depuis SharedPreferences

### Avant (Non Sécurisé)
```dart
final prefs = await SharedPreferences.getInstance();
await prefs.setString('token', token);
```

### Après (Sécurisé)
```dart
final secureStorage = SecureStorageService();
await secureStorage.saveToken(token);
```

## 🔧 Configuration

### Dépendances

Ajout dans `pubspec.yaml` :
```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

### Permissions

#### Android
Aucune permission supplémentaire nécessaire. `EncryptedSharedPreferences` est inclus dans Android.

#### iOS
Aucune permission supplémentaire nécessaire. Le Keychain est disponible par défaut.

## ✨ Améliorations Futures

- [ ] Refresh token automatique
- [ ] Expiration du token avec notification
- [ ] Biométrie pour l'authentification
- [ ] Multi-comptes support
- [ ] Synchronisation cloud sécurisée
- [ ] Audit log des authentifications
- [ ] Rate limiting pour les tentatives de login

## 🐛 Gestion des Erreurs

### Erreurs de Stockage
- Gestion silencieuse des erreurs de lecture
- Logging en mode debug
- Fallback vers état non authentifié

### Erreurs de Validation
- Détection des tokens expirés
- Déconnexion automatique
- Message d'erreur utilisateur-friendly

### Erreurs Réseau
- Pas de déconnexion sur erreurs réseau temporaires
- Retry automatique possible
- Gestion gracieuse des timeouts

