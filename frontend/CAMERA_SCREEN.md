# Camera Screen - Documentation

## ✅ Fonctionnalités Implémentées

### 1. **Utilisation de la Caméra du Dispositif**
- ✅ Accès à la caméra via le package `camera`
- ✅ Détection automatique des caméras disponibles
- ✅ Préférence pour la caméra frontale (selfie)
- ✅ Fallback sur la première caméra disponible
- ✅ Preview en temps réel de la caméra
- ✅ Résolution haute qualité (ResolutionPreset.high)

### 2. **Capture d'Image de Visage**
- ✅ Bouton de capture circulaire
- ✅ Guide visuel pour positionner le visage
- ✅ Instructions à l'écran
- ✅ Preview de l'image capturée
- ✅ Option de reprendre la photo

### 3. **Conversion en Base64**
- ✅ Lecture du fichier image
- ✅ Conversion en bytes
- ✅ Encodage en base64
- ✅ Affichage de la taille de l'image (debug)
- ✅ Stockage temporaire de l'image base64

### 4. **Envoi à l'API Spring Boot**
- ✅ Envoi via `detectEmotionFromBase64()`
- ✅ Conversion base64 → bytes → MultipartFile
- ✅ POST vers `/api/emotions/detect`
- ✅ Gestion des erreurs
- ✅ Feedback visuel (loading, success, error)
- ✅ Navigation automatique après succès

## 📋 Structure du Code

### CameraScreen (`lib/screens/camera/camera_screen.dart`)

```dart
- _initializeCamera() : Initialise la caméra
- _captureImage() : Capture l'image et convertit en base64
- _retakePhoto() : Permet de reprendre la photo
- _sendBase64ToAPI() : Envoie l'image base64 à l'API
- _buildCameraScreen() : Interface de capture
- _buildPreviewScreen() : Interface de preview
```

### ApiService (`lib/services/api_service.dart`)

```dart
- detectEmotionFromBase64(base64Image) : Nouvelle méthode
  - Décode base64 en bytes
  - Crée MultipartFile
  - Envoie via FormData
```

### EmotionProvider (`lib/providers/emotion_provider.dart`)

```dart
- detectEmotionFromBase64(base64Image) : Nouvelle méthode
  - Appelle ApiService
  - Gère les états (loading, error)
  - Met à jour la liste des émotions
```

## 🎨 Interface Utilisateur

### Écran de Capture
- **Fond noir** : Pour une meilleure visibilité
- **Preview caméra** : Plein écran
- **Guide visuel** : Rectangle blanc pour positionner le visage
- **Instructions** : "Position your face in the frame"
- **Bouton capture** : Cercle blanc avec bordure bleue
- **Indicateur** : "Tap to capture"

### Écran de Preview
- **Image capturée** : Plein écran
- **Info taille** : Affiche la taille de l'image base64
- **Bouton Send** : Envoie à l'API
- **Bouton Retake** : Reprendre la photo

## 🔄 Flux de Fonctionnement

### Initialisation
1. Détection des caméras disponibles
2. Sélection de la caméra frontale (ou première disponible)
3. Initialisation du contrôleur caméra
4. Affichage du preview

### Capture
1. Utilisateur positionne son visage
2. Appuie sur le bouton de capture
3. Image capturée et sauvegardée
4. Conversion en base64
5. Affichage du preview avec options

### Envoi
1. Utilisateur clique sur "Send to API"
2. Base64 est décodé en bytes
3. Création d'un MultipartFile
4. Envoi POST à `/api/emotions/detect`
5. Réception de l'émotion détectée
6. Sauvegarde dans la base de données
7. Navigation retour avec succès

## 📦 Dépendances

### Nouvelle Dépendance
```yaml
camera: ^0.10.5+5
```

### Installation
```bash
flutter pub get
```

## 🔐 Permissions

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera" android:required="false"/>
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to capture face images for emotion detection</string>
```

## 🚀 Utilisation

### Navigation vers l'écran caméra
```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => const CameraScreen(),
  ),
).then((success) {
  if (success == true) {
    // Emotion detected successfully
  }
});
```

### Intégration dans le Dashboard
Le dashboard patient peut ouvrir cet écran au lieu d'utiliser `image_picker` directement.

## 📝 Notes Techniques

### Conversion Base64
```dart
// Lecture du fichier
final File imageFile = File(image.path);
final List<int> imageBytes = await imageFile.readAsBytes();

// Encodage base64
final String base64Image = base64Encode(imageBytes);
```

### Envoi à l'API
```dart
// Décodage base64
final bytes = base64Decode(base64Image);

// Création MultipartFile
final multipartFile = MultipartFile.fromBytes(
  bytes,
  filename: 'face_image.jpg',
);

// Envoi via FormData
FormData formData = FormData.fromMap({
  'image': multipartFile,
});
```

## ✨ Améliorations Futures

- [ ] Détection de visage en temps réel (face detection overlay)
- [ ] Flash automatique si nécessaire
- [ ] Zoom avant/arrière
- [ ] Rotation de l'image si nécessaire
- [ ] Compression d'image avant envoi
- [ ] Support de plusieurs formats (JPEG, PNG)
- [ ] Historique des images capturées

