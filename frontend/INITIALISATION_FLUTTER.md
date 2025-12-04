# Initialisation du Projet Flutter

## Étape 1: Initialiser la Structure Flutter

Dans le dossier du projet, exécutez:

```powershell
cd C:\Users\Dell\Desktop\flutter_app
C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter create .
```

Cette commande va créer la structure complète Flutter (dossiers `android/`, `ios/`, `web/`, etc.) sans écraser les fichiers existants.

## Étape 2: Configurer AndroidManifest.xml

Après l'initialisation, modifiez `android/app/src/main/AndroidManifest.xml`:

### Ajouter les permissions (avant la balise `<application>`):

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
```

### Ajouter `android:usesCleartextTraffic="true"` dans la balise `<application>`:

```xml
<application
    android:label="emotion_monitoring"
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher"
    android:usesCleartextTraffic="true">
```

Cela permet les connexions HTTP (non-HTTPS) pour le développement local.

## Étape 3: Installer les Dépendances

```powershell
C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter pub get
```

## Étape 4: Vérifier la Configuration

```powershell
C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter doctor
```

## Étape 5: Lancer l'Application

```powershell
C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter run
```

## Structure Créée

Après `flutter create .`, vous aurez:

```
flutter_app/
├── android/          # Configuration Android
├── ios/              # Configuration iOS
├── web/              # Configuration Web
├── windows/          # Configuration Windows
├── lib/              # Code source (déjà créé)
├── test/             # Tests
├── pubspec.yaml      # Dépendances (déjà créé)
└── ...
```

## Notes Importantes

1. **Ne pas exécuter `flutter create` si vous avez déjà un projet Flutter initialisé**
2. **Les fichiers dans `lib/` sont déjà créés et ne seront pas écrasés**
3. **Le `pubspec.yaml` existe déjà et sera préservé**

## Alternative: Créer un Nouveau Projet

Si vous préférez créer un nouveau projet séparé:

```powershell
cd C:\Users\Dell\Desktop
C:\Users\Dell\Desktop\flutter_windows_3.38.3-stable\flutter\bin\flutter create emotion_monitoring_app
cd emotion_monitoring_app
# Copier les fichiers de lib/ dans le nouveau projet
```

