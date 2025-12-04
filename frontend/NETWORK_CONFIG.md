# 🌐 Configuration Réseau pour Application Flutter

## ✅ Configuration Actuelle

L'URL de base de l'API est configurée dans `lib/config/app_config.dart` :

```dart
static const String baseUrl = 'http://192.168.3.55:8080/api';
```

## 📱 Application Mobile vs Web

**Important** : Pour une application Flutter mobile (Android/iOS), CORS ne s'applique **PAS**. CORS est une restriction des navigateurs web uniquement. Les applications mobiles font des requêtes HTTP directes et ne sont pas affectées par CORS.

## 🔧 Vérifications Requises

### 1. Backend Spring Boot

Assurez-vous que le backend est démarré et accessible :

```bash
# Le backend doit être accessible sur http://192.168.3.55:8080
# Par défaut, Spring Boot écoute sur toutes les interfaces (0.0.0.0)
```

### 2. Firewall Windows

Autorisez les connexions entrantes sur le port 8080 :

**Via PowerShell (Administrateur)** :
```powershell
New-NetFirewallRule -DisplayName "Spring Boot Backend" -Direction Inbound -LocalPort 8080 -Protocol TCP -Action Allow
```

**Via Interface Graphique** :
1. Ouvrir "Pare-feu Windows Defender"
2. Paramètres avancés
3. Règles de trafic entrant → Nouvelle règle
4. Port → TCP → 8080 → Autoriser la connexion

### 3. Réseau

- ✅ L'appareil Android et le PC doivent être sur le **même réseau Wi-Fi**
- ✅ Vérifiez que l'IP `192.168.3.55` est correcte (peut changer si le PC redémarre)
- ✅ Testez la connexion depuis l'appareil Android avec un navigateur : `http://192.168.3.55:8080/api/auth/register`

### 4. Vérification de l'IP

Pour trouver l'IP actuelle de votre PC :

**Windows PowerShell** :
```powershell
ipconfig | findstr IPv4
```

**Windows CMD** :
```cmd
ipconfig
```

Cherchez l'adresse IPv4 de votre carte réseau Wi-Fi (généralement commence par `192.168.x.x`).

## 🧪 Test de Connexion

### Depuis l'appareil Android

1. Ouvrez un navigateur sur l'appareil Android
2. Accédez à : `http://192.168.3.55:8080/api/auth/register`
3. Vous devriez voir une réponse JSON (même si c'est une erreur, cela confirme que la connexion fonctionne)

### Depuis l'application Flutter

L'application devrait maintenant se connecter automatiquement au backend sur `http://192.168.3.55:8080/api`.

## 🔄 Changer l'URL de Base

Si vous devez changer l'URL de base :

1. Modifiez `frontend/lib/config/app_config.dart`
2. Changez la ligne :
   ```dart
   static const String baseUrl = 'http://VOTRE_IP:8080/api';
   ```
3. Redémarrez l'application Flutter

## 📝 Notes

- Pour le développement local avec un émulateur Android, vous pouvez utiliser `http://10.0.2.2:8080/api` (IP spéciale de l'émulateur Android pour accéder à localhost de la machine hôte)
- Pour un appareil physique, utilisez toujours l'IP locale de votre PC (ex: `192.168.3.55`)
- Si l'IP change, mettez à jour `app_config.dart` et redémarrez l'app

## 🐛 Dépannage

**Problème** : L'app ne peut pas se connecter au backend

**Solutions** :
1. Vérifiez que le backend est démarré : `http://192.168.3.55:8080/api/auth/register`
2. Vérifiez le firewall Windows
3. Vérifiez que l'IP est correcte : `ipconfig`
4. Vérifiez que l'appareil et le PC sont sur le même réseau Wi-Fi
5. Testez depuis un navigateur sur l'appareil Android

**Problème** : Erreur de timeout

**Solutions** :
1. Vérifiez que le backend répond rapidement
2. Augmentez les timeouts dans `app_config.dart` si nécessaire
3. Vérifiez la connexion réseau

