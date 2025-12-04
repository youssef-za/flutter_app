# Démarrage Rapide - Flutter

## 🚀 Étapes Rapides

### 1. Initialiser le Projet (Première fois seulement)

```powershell
cd C:\Users\Dell\Desktop\flutter_app
C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter create .
```

### 2. Installer les Dépendances

```powershell
C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter pub get
```

### 3. Configurer AndroidManifest.xml

Ouvrez `android/app/src/main/AndroidManifest.xml` et ajoutez:

**Permissions (avant `<application>`):**
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
```

**Dans la balise `<application>`, ajoutez:**
```xml
android:usesCleartextTraffic="true"
```

### 4. Démarrer le Backend Spring Boot

```powershell
# Dans un autre terminal
cd C:\Users\Dell\Desktop\flutter_app
mvn spring-boot:run
```

### 5. Lancer l'Application Flutter

```powershell
C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter run
```

## 📱 Tester l'Application

1. **Inscription:**
   - Ouvrir l'app
   - Cliquer sur "Register"
   - Remplir le formulaire
   - S'inscrire

2. **Connexion:**
   - Se connecter avec les identifiants créés

3. **Enregistrer une Émotion:**
   - Onglet "Emotions"
   - Sélectionner un type d'émotion
   - Ajuster la confiance
   - Cliquer sur "Save Emotion"

4. **Détecter depuis la Caméra:**
   - Cliquer sur "Take Photo"
   - Prendre une photo
   - L'émotion sera détectée automatiquement

5. **Voir l'Historique:**
   - Onglet "History"
   - Voir toutes les émotions enregistrées

## 🔧 Configuration de l'URL Backend

Si le backend n'est pas sur `localhost:8080`, modifiez `lib/services/api_service.dart`:

```dart
static const String baseUrl = 'http://VOTRE_IP:8080/api';
```

**Pour un appareil physique Android:**
- Trouvez l'IP de votre PC: `ipconfig`
- Utilisez cette IP au lieu de `localhost`

## ⚠️ Dépannage

### Erreur: "Flutter command not found"
Utilisez le chemin complet ou ajoutez Flutter au PATH.

### Erreur: "No devices found"
- Connectez un appareil Android via USB
- Activez le mode développeur
- Ou utilisez un émulateur
- Ou testez sur Chrome: `flutter run -d chrome`

### Erreur de connexion au backend
- Vérifiez que le backend est démarré
- Vérifiez l'URL dans `api_service.dart`
- Pour un appareil physique, utilisez l'IP de votre PC

### Erreur: "Package not found"
```powershell
flutter pub get
flutter clean
flutter pub get
```

## ✅ Checklist

- [ ] Flutter SDK 3.38.3 installé
- [ ] Projet initialisé avec `flutter create .`
- [ ] Dépendances installées avec `flutter pub get`
- [ ] AndroidManifest.xml configuré
- [ ] Backend Spring Boot démarré
- [ ] Application Flutter lancée
- [ ] Test d'inscription réussi
- [ ] Test de connexion réussi
- [ ] Test d'enregistrement d'émotion réussi

