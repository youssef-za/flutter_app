# Navigation System - Documentation

## ✅ Fonctionnalités Implémentées

### 1. **Système de Navigation Centralisé**
- ✅ Service de navigation centralisé (`NavigationService`)
- ✅ Routes nommées dans `AppRoutes`
- ✅ Navigation avec arguments
- ✅ Navigation avec remplacement
- ✅ Navigation avec suppression de la pile
- ✅ Helper methods pour chaque écran

### 2. **Routes Définies**
- ✅ Splash Screen (`/`)
- ✅ Login (`/login`)
- ✅ Register (`/register`)
- ✅ Home (`/home`)
- ✅ Patient Dashboard (`/home/patient-dashboard`)
- ✅ Doctor Dashboard (`/home/doctor-dashboard`)
- ✅ Emotion Capture (`/emotion/capture`)
- ✅ Emotion History (`/emotion/history`)

### 3. **Navigation Helper Methods**
- ✅ `toLogin()` - Navigate to login
- ✅ `toRegister()` - Navigate to register
- ✅ `toHome()` - Navigate to home
- ✅ `toPatientDashboard()` - Navigate to patient dashboard
- ✅ `toDoctorDashboard()` - Navigate to doctor dashboard
- ✅ `toEmotionCapture()` - Navigate to camera screen
- ✅ `toEmotionHistory()` - Navigate to history
- ✅ `logout()` - Logout and navigate to login

### 4. **Intégration Complète**
- ✅ Tous les écrans utilisent le système centralisé
- ✅ Navigation cohérente dans toute l'application
- ✅ Gestion des arguments de route
- ✅ Support des routes dynamiques

## 📋 Structure du Code

### AppRoutes (`lib/config/app_routes.dart`)
```dart
- Définition de toutes les routes de l'application
- Routes constantes pour éviter les erreurs de typo
- Organisation par catégories (auth, home, emotion)
```

### NavigationService (`lib/services/navigation_service.dart`)
```dart
- navigatorKey: Clé globale pour le Navigator
- navigateTo(): Navigation basique
- navigateToReplacement(): Remplace la route actuelle
- navigateToAndRemoveUntil(): Supprime toutes les routes précédentes
- goBack(): Retour en arrière
- Helper methods pour chaque écran
```

### Main (`lib/main.dart`)
```dart
- Configuration du MaterialApp avec navigatorKey
- Définition de toutes les routes
- onGenerateRoute pour les routes dynamiques
- Support des arguments de route
```

## 🎯 Utilisation

### Navigation Basique

```dart
// Navigate to a screen
NavigationService.toLogin();

// Navigate with replacement
NavigationService.toHome(replace: true);

// Navigate and remove all previous routes
NavigationService.logout();
```

### Navigation avec Arguments

```dart
// Navigate with arguments
NavigationService.navigateTo(
  AppRoutes.emotionHistory,
  arguments: {'patientId': 123},
);

// Access arguments in the screen
final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
final patientId = args['patientId'];
```

### Retour en Arrière

```dart
// Go back
NavigationService.goBack();

// Go back with result
NavigationService.goBack(true);

// Go back until specific route
NavigationService.goBackUntil(AppRoutes.home);
```

### Navigation Conditionnelle

```dart
// Check if can go back
if (NavigationService.canGoBack()) {
  NavigationService.goBack();
} else {
  NavigationService.toHome();
}
```

## 🔄 Flux de Navigation

### 1. Démarrage de l'Application
```
SplashScreen → Auto-login check
  ├─ Authenticated → HomeScreen
  └─ Not Authenticated → LoginScreen
```

### 2. Authentification
```
LoginScreen
  ├─ Login Success → HomeScreen
  ├─ Register → RegisterScreen
  └─ Register Success → HomeScreen
```

### 3. Patient Flow
```
HomeScreen (Patient Dashboard)
  ├─ Capture Emotion → CameraScreen → HomeScreen
  ├─ View History → HistoryTab (same screen)
  └─ Profile → ProfileTab (same screen)
```

### 4. Doctor Flow
```
HomeScreen (Doctor Dashboard)
  ├─ View Patients → Doctor Dashboard (same screen)
  ├─ View History → HistoryTab (same screen)
  └─ Profile → ProfileTab (same screen)
```

### 5. Déconnexion
```
Any Screen → Logout → LoginScreen (clear all routes)
```

## 📱 Écrans Disponibles

### 1. **Splash Screen** (`/`)
- Écran de démarrage
- Vérification de l'authentification
- Navigation automatique

### 2. **Login Screen** (`/login`)
- Connexion utilisateur
- Navigation vers Register
- Navigation vers Home après connexion

### 3. **Register Screen** (`/register`)
- Inscription utilisateur
- Navigation vers Login
- Navigation vers Home après inscription

### 4. **Home Screen** (`/home`)
- Écran principal avec tabs
- Dashboard Patient ou Doctor selon le rôle
- Navigation entre tabs

### 5. **Patient Dashboard** (`/home/patient-dashboard`)
- Affichage de l'émotion actuelle
- Bouton pour capturer une émotion
- Accès à l'historique

### 6. **Doctor Dashboard** (`/home/doctor-dashboard`)
- Liste des patients
- Dernières émotions
- Alertes en temps réel

### 7. **Emotion Capture** (`/emotion/capture`)
- Capture d'image avec caméra
- Détection d'émotion
- Retour avec résultat

### 8. **Emotion History** (`/emotion/history`)
- Historique des émotions
- Graphiques
- Filtres et recherche

## 🔧 Configuration

### Ajouter une Nouvelle Route

1. **Définir la route dans AppRoutes**
```dart
class AppRoutes {
  static const String newScreen = '/new-screen';
}
```

2. **Ajouter la route dans main.dart**
```dart
routes: {
  AppRoutes.newScreen: (context) => const NewScreen(),
}
```

3. **Créer un helper method dans NavigationService**
```dart
static Future<dynamic>? toNewScreen() {
  return navigateTo(AppRoutes.newScreen);
}
```

4. **Utiliser la navigation**
```dart
NavigationService.toNewScreen();
```

## ✨ Avantages

### 1. **Centralisation**
- Toutes les routes au même endroit
- Facile à maintenir et modifier
- Évite les erreurs de typo

### 2. **Type Safety**
- Routes constantes
- Autocomplétion IDE
- Détection d'erreurs à la compilation

### 3. **Réutilisabilité**
- Helper methods réutilisables
- Code DRY (Don't Repeat Yourself)
- Navigation cohérente

### 4. **Maintenabilité**
- Changements centralisés
- Facile à déboguer
- Documentation claire

### 5. **Testabilité**
- Navigation facile à tester
- Mock du NavigationService possible
- Tests unitaires simplifiés

## 🐛 Gestion des Erreurs

### Route Non Trouvée
```dart
onUnknownRoute: (settings) {
  return MaterialPageRoute(
    builder: (_) => const NotFoundScreen(),
  );
}
```

### Arguments Manquants
```dart
final args = ModalRoute.of(context)?.settings.arguments;
if (args == null) {
  // Handle missing arguments
  NavigationService.goBack();
  return;
}
```

## 📝 Notes Techniques

### Navigator Key
- Utilisé pour accéder au Navigator depuis n'importe où
- Permet la navigation depuis les services
- Nécessaire pour les tests

### Route Arguments
- Passés via `arguments` parameter
- Récupérés via `ModalRoute.of(context)!.settings.arguments`
- Type-safe avec casting approprié

### Deep Linking
- Support possible avec `onGenerateRoute`
- Arguments passés via URL
- Navigation directe vers un écran spécifique

## 🚀 Améliorations Futures

- [ ] Deep linking support
- [ ] Navigation guards (route protection)
- [ ] Animation personnalisées
- [ ] Navigation avec transitions
- [ ] Breadcrumb navigation
- [ ] Navigation history
- [ ] Analytics de navigation

