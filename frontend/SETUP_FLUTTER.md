# Guide d'Installation Flutter

## Prérequis

1. **Flutter SDK 3.38.3-stable** (déjà installé dans `C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter`)

2. **Ajouter Flutter au PATH** (optionnel mais recommandé):
   - Ouvrir les Variables d'Environnement Windows
   - Ajouter `C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin` au PATH

## Installation des Dépendances

1. **Ouvrir un terminal dans le dossier du projet:**
   ```powershell
   cd C:\Users\Dell\Desktop\flutter_app
   ```

2. **Installer les dépendances Flutter:**
   ```powershell
   C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter pub get
   ```

   Ou si Flutter est dans le PATH:
   ```powershell
   flutter pub get
   ```

## Vérification

1. **Vérifier que Flutter fonctionne:**
   ```powershell
   C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter doctor
   ```

2. **Vérifier les appareils disponibles:**
   ```powershell
   C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter devices
   ```

## Configuration

### 1. URL du Backend

Par défaut, l'application se connecte à `http://localhost:8080/api`.

Pour changer l'URL, modifiez `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://VOTRE_IP:8080/api';
```

**Pour tester sur un appareil physique Android:**
- Trouvez l'IP de votre ordinateur: `ipconfig` (Windows)
- Utilisez cette IP au lieu de `localhost`
- Exemple: `http://192.168.1.100:8080/api`

### 2. Permissions Android (pour la caméra)

Ajoutez dans `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

## Lancer l'Application

### Option 1: Avec Flutter dans le PATH
```powershell
flutter run
```

### Option 2: Avec le chemin complet
```powershell
C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter run
```

### Option 3: Spécifier un appareil
```powershell
flutter run -d chrome          # Pour tester sur Chrome
flutter run -d windows         # Pour tester sur Windows (si supporté)
flutter devices                # Voir les appareils disponibles
```

## Structure du Projet

```
flutter_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   ├── providers/
│   ├── screens/
│   └── services/
├── pubspec.yaml
└── README_FLUTTER.md
```

## Dépannage

### Erreur: "Flutter command not found"
- Ajoutez Flutter au PATH ou utilisez le chemin complet

### Erreur: "No devices found"
- Connectez un appareil Android via USB avec le mode développeur activé
- Ou utilisez un émulateur Android
- Ou testez sur Chrome: `flutter run -d chrome`

### Erreur de connexion au backend
- Vérifiez que le backend Spring Boot est démarré
- Vérifiez l'URL dans `api_service.dart`
- Pour un appareil physique, utilisez l'IP de votre ordinateur au lieu de `localhost`

### Erreur: "Package not found"
```powershell
flutter pub get
flutter clean
flutter pub get
```

## Prochaines Étapes

1. Démarrer le backend Spring Boot
2. Lancer l'application Flutter
3. Tester l'inscription et la connexion
4. Tester l'enregistrement d'émotions
5. Tester la détection d'émotion depuis la caméra

