# API Service - Documentation

## ✅ Fonctionnalités Implémentées

### 1. **Gestion Centralisée des Requêtes HTTP**
- ✅ Méthodes génériques GET, POST, PUT, DELETE
- ✅ Support des query parameters
- ✅ Support des options personnalisées
- ✅ Parsing personnalisé des réponses

### 2. **Attachement Automatique du JWT Token**
- ✅ Intercepteur de requête automatique
- ✅ Récupération du token depuis SharedPreferences
- ✅ Ajout automatique du header `Authorization: Bearer {token}`
- ✅ Gestion silencieuse si token absent

### 3. **Gestion Complète des Erreurs**
- ✅ Classe `ApiException` pour les erreurs personnalisées
- ✅ Gestion des erreurs réseau (timeout, connexion)
- ✅ Gestion des erreurs HTTP (400, 401, 403, 404, 500, etc.)
- ✅ Extraction des messages d'erreur depuis la réponse
- ✅ Messages d'erreur utilisateur-friendly
- ✅ Détection automatique du type d'erreur

### 4. **Wrapper de Réponse**
- ✅ Classe `ApiResponse<T>` pour wrapper les réponses
- ✅ Méthodes helper (`getDataOrThrow()`, `getDataOrNull()`)
- ✅ Indicateur de succès/échec
- ✅ Conservation du status code

### 5. **Logging et Debug**
- ✅ Logging optionnel des requêtes/réponses
- ✅ Mode debug configurable
- ✅ Affichage des headers et données

### 6. **Gestion de l'Authentification**
- ✅ Détection automatique des erreurs 401
- ✅ Nettoyage automatique du token expiré
- ✅ Suppression des données utilisateur

## 📋 Structure du Code

### ApiException (`lib/services/api_exception.dart`)
```dart
- message: Message d'erreur
- statusCode: Code de statut HTTP (optionnel)
- originalError: Erreur originale (optionnel)
- isUnauthorized: Vérifie si 401
- isForbidden: Vérifie si 403
- isNotFound: Vérifie si 404
- isServerError: Vérifie si >= 500
- isClientError: Vérifie si 400-499
```

### ApiResponse (`lib/services/api_response.dart`)
```dart
- data: Données de la réponse (optionnel)
- error: Exception API (optionnel)
- statusCode: Code de statut HTTP (optionnel)
- isSuccess: Indicateur de succès
- getDataOrThrow(): Récupère les données ou lance une exception
- getDataOrNull(): Récupère les données ou null
- errorMessage: Message d'erreur formaté
```

### ApiService (`lib/services/api_service.dart`)
```dart
- Méthodes génériques: get(), post(), put(), delete()
- Méthodes spécifiques: register(), login(), createEmotion(), etc.
- Intercepteurs: _setupInterceptors()
- Gestion d'erreurs: _handleError()
- Attachement token: _attachToken()
```

## 🎯 Utilisation

### Exemple 1: Utilisation avec ApiResponse

```dart
final apiService = ApiService();

// GET request
final response = await apiService.get<Map<String, dynamic>>('/users/1');

if (response.isSuccess) {
  final userData = response.data;
  // Traiter les données
} else {
  final errorMessage = response.errorMessage;
  // Afficher l'erreur
}
```

### Exemple 2: Utilisation avec try-catch

```dart
try {
  final response = await apiService.get<Map<String, dynamic>>('/users/1');
  final userData = response.getDataOrThrow();
  // Traiter les données
} on ApiException catch (e) {
  if (e.isUnauthorized) {
    // Rediriger vers login
  } else {
    // Afficher l'erreur
    print(e.message);
  }
}
```

### Exemple 3: POST avec données

```dart
final response = await apiService.post<Map<String, dynamic>>(
  '/emotions',
  data: {
    'emotionType': 'HAPPY',
    'confidence': 0.95,
  },
);

if (response.isSuccess) {
  final emotion = EmotionModel.fromJson(response.data!);
  // Traiter l'émotion
}
```

### Exemple 4: GET avec query parameters

```dart
final response = await apiService.get<List<dynamic>>(
  '/emotions',
  queryParameters: {
    'patientId': 1,
    'limit': 10,
  },
);
```

### Exemple 5: Parsing personnalisé

```dart
final response = await apiService.get<EmotionModel>(
  '/emotions/1',
  parser: (data) => EmotionModel.fromJson(data as Map<String, dynamic>),
);
```

## 🔄 Gestion des Erreurs

### Types d'Erreurs Gérées

1. **Timeout Errors**
   - Connection timeout
   - Send timeout
   - Receive timeout
   - Message: "Request timeout. Please check your connection and try again."

2. **Network Errors**
   - No internet connection
   - DNS lookup failed
   - Message: "No internet connection. Please check your network and try again."

3. **HTTP Errors**
   - 400: Bad request
   - 401: Unauthorized (token automatiquement supprimé)
   - 403: Forbidden
   - 404: Not found
   - 409: Conflict
   - 422: Validation error
   - 500+: Server errors

4. **Unknown Errors**
   - Erreurs non catégorisées
   - Message: "An unexpected error occurred. Please try again."

### Extraction des Messages d'Erreur

L'API service essaie d'extraire le message d'erreur depuis la réponse dans cet ordre:
1. `message`
2. `error`
3. `Message`
4. `Error`
5. Message par défaut basé sur le status code

## 🔐 Sécurité

### JWT Token
- Attaché automatiquement à toutes les requêtes
- Récupéré depuis SharedPreferences
- Format: `Authorization: Bearer {token}`
- Supprimé automatiquement en cas d'erreur 401

### Headers par Défaut
- `Content-Type: application/json`
- `Accept: application/json`

## 📝 Configuration

### AppConfig
```dart
static const String baseUrl = 'http://localhost:8080/api';
static const Duration connectTimeout = Duration(seconds: 10);
static const Duration receiveTimeout = Duration(seconds: 10);
static const bool debugMode = true; // false en production
```

### Timeouts
- `connectTimeout`: Temps d'attente pour établir la connexion
- `receiveTimeout`: Temps d'attente pour recevoir la réponse
- `sendTimeout`: Temps d'attente pour envoyer la requête

## 🚀 Migration depuis l'Ancien Code

### Avant (Legacy)
```dart
try {
  final response = await apiService.login(email, password);
  if (response.statusCode == 200) {
    // Success
  }
} catch (e) {
  // Error handling
}
```

### Après (Nouveau)
```dart
final response = await apiService.login(email, password);
if (response.isSuccess) {
  final data = response.data;
  // Success
} else {
  final errorMessage = response.errorMessage;
  // Error handling
}
```

## ✨ Améliorations Futures

- [ ] Retry automatique pour certaines erreurs
- [ ] Cache des réponses
- [ ] Compression des requêtes
- [ ] Rate limiting
- [ ] Request queuing
- [ ] Offline support
- [ ] Request cancellation
- [ ] Progress tracking pour uploads

