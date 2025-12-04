# Configuration de la Caméra - Guide d'Installation

## 📦 Installation des Dépendances

### 1. Ajouter le package camera

Le package `camera` a été ajouté au `pubspec.yaml`:

```yaml
camera: ^0.10.5+5
```

### 2. Installer les dépendances

```bash
cd frontend
flutter pub get
```

## 🔐 Configuration des Permissions

### Android

#### 1. Modifier `android/app/src/main/AndroidManifest.xml`

Ajoutez les permissions avant la balise `<application>`:

```xml
<uses-permission android:name="android.permission.CAMERA"/>
<uses-feature android:name="android.hardware.camera" android:required="false"/>
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>
```

#### 2. Configuration complète AndroidManifest.xml

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.example.emotion_monitoring">

    <!-- Permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.CAMERA"/>
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
    
    <!-- Camera Features -->
    <uses-feature android:name="android.hardware.camera" android:required="false"/>
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>

    <application
        android:label="emotion_monitoring"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">
        
        <!-- ... reste de la configuration ... -->
    </application>
</manifest>
```

### iOS

#### 1. Modifier `ios/Runner/Info.plist`

Ajoutez la description d'utilisation de la caméra:

```xml
<key>NSCameraUsageDescription</key>
<string>We need access to your camera to capture face images for emotion detection</string>
```

#### 2. Configuration complète Info.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- ... autres clés ... -->
    
    <key>NSCameraUsageDescription</key>
    <string>We need access to your camera to capture face images for emotion detection</string>
    
    <!-- ... autres clés ... -->
</dict>
</plist>
```

## 🚀 Utilisation

### Navigation vers l'écran caméra

```dart
import 'package:emotion_monitoring/screens/camera/camera_screen.dart';

// Depuis n'importe quel écran
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => const CameraScreen(),
  ),
).then((success) {
  if (success == true) {
    // Emotion détectée avec succès
    print('Emotion detected!');
  }
});
```

### Intégration dans le Dashboard Patient

Le dashboard patient utilise déjà l'écran caméra. Le bouton "Capture New Emotion" ouvre automatiquement `CameraScreen`.

## 🔧 Dépannage

### Erreur: "Camera not available"
- Vérifiez que les permissions sont bien configurées
- Vérifiez que l'appareil a une caméra
- Redémarrez l'application après avoir ajouté les permissions

### Erreur: "Camera initialization failed"
- Vérifiez les permissions dans les paramètres de l'appareil
- Assurez-vous qu'aucune autre app n'utilise la caméra
- Redémarrez l'application

### Erreur: "No cameras available"
- Vérifiez que l'émulateur/Appareil a une caméra
- Pour Android Emulator: Settings > Extended Controls > Camera

## 📝 Notes

- L'écran caméra préfère la caméra frontale (selfie)
- Si la caméra frontale n'est pas disponible, utilise la première caméra
- L'image est convertie en base64 avant l'envoi
- L'image est envoyée via MultipartFile à l'API Spring Boot

## ✅ Checklist

- [ ] Package `camera` ajouté au `pubspec.yaml`
- [ ] `flutter pub get` exécuté
- [ ] Permissions Android configurées
- [ ] Permissions iOS configurées (si iOS)
- [ ] Test de l'écran caméra
- [ ] Test de capture d'image
- [ ] Test d'envoi à l'API

