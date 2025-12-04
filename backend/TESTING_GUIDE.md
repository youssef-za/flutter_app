# Guide de Test du Backend - Medical Emotion Monitoring System

Ce guide vous montre comment tester toutes les fonctionnalités de l'API backend.

## Prérequis

1. **Démarrer l'application Spring Boot**
   ```bash
   mvn spring-boot:run
   ```
   L'application sera accessible sur : `http://localhost:8080/api`

2. **Outils recommandés pour tester :**
   - **Postman** (recommandé) : https://www.postman.com/downloads/
   - **Insomnia** : https://insomnia.rest/download
   - **curl** (ligne de commande)
   - **Thunder Client** (extension VS Code)

## 1. Test d'Authentification

### 1.1 Inscription (Register)

**Endpoint:** `POST http://localhost:8080/api/auth/register`

**Headers:**
```
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "fullName": "John Doe",
  "email": "john.doe@example.com",
  "password": "password123"
}
```

**Réponse attendue (201 Created):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "type": "Bearer",
  "id": 1,
  "fullName": "John Doe",
  "email": "john.doe@example.com",
  "role": "PATIENT"
}
```

**Commande curl:**
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "John Doe",
    "email": "john.doe@example.com",
    "password": "password123"
  }'
```

### 1.2 Connexion (Login)

**Endpoint:** `POST http://localhost:8080/api/auth/login`

**Headers:**
```
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "email": "john.doe@example.com",
  "password": "password123"
}
```

**Réponse attendue (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "type": "Bearer",
  "id": 1,
  "fullName": "John Doe",
  "email": "john.doe@example.com",
  "role": "PATIENT"
}
```

**Commande curl:**
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john.doe@example.com",
    "password": "password123"
  }'
```

**⚠️ IMPORTANT:** Copiez le `token` de la réponse pour les prochains tests !

### 1.3 Validation du Token

**Endpoint:** `GET http://localhost:8080/api/auth/validate`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
```

**Commande curl:**
```bash
curl -X GET http://localhost:8080/api/auth/validate \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 2. Test des Emotions

### 2.1 Créer une Emotion (Manuelle)

**Endpoint:** `POST http://localhost:8080/api/emotions`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "emotionType": "SAD",
  "confidence": 0.85,
  "timestamp": "2024-01-15T10:30:00"
}
```

**Types d'émotions disponibles:**
- `HAPPY`
- `SAD`
- `ANGRY`
- `FEAR`
- `NEUTRAL`

**Commande curl:**
```bash
curl -X POST http://localhost:8080/api/emotions \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d '{
    "emotionType": "SAD",
    "confidence": 0.85
  }'
```

### 2.2 Détecter Emotion depuis une Image

**Endpoint:** `POST http://localhost:8080/api/emotions/detect`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
Content-Type: multipart/form-data
```

**Body (form-data):**
- Key: `image`
- Type: File
- Value: Sélectionnez une image (JPG, PNG, etc.)

**Commande curl:**
```bash
curl -X POST http://localhost:8080/api/emotions/detect \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -F "image=@/path/to/your/image.jpg"
```

### 2.3 Récupérer une Emotion par ID

**Endpoint:** `GET http://localhost:8080/api/emotions/{id}`

**Exemple:** `GET http://localhost:8080/api/emotions/1`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
```

**Commande curl:**
```bash
curl -X GET http://localhost:8080/api/emotions/1 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 2.4 Récupérer l'Historique des Emotions d'un Patient

**Endpoint:** `GET http://localhost:8080/api/emotions/patient/{patientId}`

**Exemple:** `GET http://localhost:8080/api/emotions/patient/1`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
```

**Commande curl:**
```bash
curl -X GET http://localhost:8080/api/emotions/patient/1 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 3. Test des Utilisateurs

### 3.1 Récupérer un Utilisateur par ID

**Endpoint:** `GET http://localhost:8080/api/users/{id}`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
```

**Commande curl:**
```bash
curl -X GET http://localhost:8080/api/users/1 \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 3.2 Récupérer un Utilisateur par Email

**Endpoint:** `GET http://localhost:8080/api/users/email/{email}`

**Exemple:** `GET http://localhost:8080/api/users/email/john.doe@example.com`

**Headers:**
```
Authorization: Bearer YOUR_TOKEN_HERE
```

**Commande curl:**
```bash
curl -X GET "http://localhost:8080/api/users/email/john.doe@example.com" \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

### 3.3 Récupérer Tous les Utilisateurs (DOCTOR uniquement)

**Endpoint:** `GET http://localhost:8080/api/users`

**Headers:**
```
Authorization: Bearer YOUR_DOCTOR_TOKEN_HERE
```

**Note:** Seuls les utilisateurs avec le rôle DOCTOR peuvent accéder à cet endpoint.

## 4. Test du Système d'Alerte Automatique

### 4.1 Tester l'Alerte pour 3 SAD Consécutives

Pour tester le système d'alerte automatique :

1. Créez 3 émotions SAD consécutives pour le même patient :

```bash
# Emotion 1
curl -X POST http://localhost:8080/api/emotions \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"emotionType": "SAD", "confidence": 0.8}'

# Emotion 2
curl -X POST http://localhost:8080/api/emotions \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"emotionType": "SAD", "confidence": 0.75}'

# Emotion 3 - Cette émotion devrait déclencher une alerte !
curl -X POST http://localhost:8080/api/emotions \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"emotionType": "SAD", "confidence": 0.9}'
```

2. Vérifiez les logs de l'application - vous devriez voir :
   ```
   Alert created for patient 1 due to 3 consecutive SAD emotions
   ```

3. Vérifiez dans la base de données MySQL :
   ```sql
   SELECT * FROM alerts;
   ```

## 5. Scénarios de Test Complets

### Scénario 1 : Flux Complet Patient

1. **Inscription**
2. **Connexion** → Récupérer le token
3. **Créer une émotion**
4. **Récupérer l'historique des émotions**
5. **Créer 3 émotions SAD** → Vérifier l'alerte automatique

### Scénario 2 : Test avec Image

1. **Connexion** → Récupérer le token
2. **Uploader une image** pour détecter l'émotion
3. **Vérifier l'émotion détectée** dans la réponse

### Scénario 3 : Test des Rôles

1. **Créer un utilisateur PATIENT** → S'inscrire
2. **Créer un utilisateur DOCTOR** → Modifier le rôle dans la base de données
3. **Tester les permissions** :
   - PATIENT ne peut voir que ses propres données
   - DOCTOR peut voir toutes les données

## 6. Tests avec Postman

### Configuration Postman

1. **Créer une Collection** : "Medical Emotion Monitoring"
2. **Créer une Variable d'Environnement** :
   - Variable: `base_url`
   - Valeur: `http://localhost:8080/api`
   - Variable: `token`
   - Valeur: (vide, sera remplie après login)

3. **Créer un Pre-request Script pour le Login automatique** (optionnel)

### Exemples de Requêtes Postman

#### Collection: Authentication
- `POST {{base_url}}/auth/register`
- `POST {{base_url}}/auth/login` → Sauvegarder le token dans la variable `token`
- `GET {{base_url}}/auth/validate`

#### Collection: Emotions
- `POST {{base_url}}/emotions` → Headers: `Authorization: Bearer {{token}}`
- `POST {{base_url}}/emotions/detect` → Body: form-data, key: `image`
- `GET {{base_url}}/emotions/1`
- `GET {{base_url}}/emotions/patient/1`

#### Collection: Users
- `GET {{base_url}}/users/1`
- `GET {{base_url}}/users/email/john.doe@example.com`

## 7. Vérification de la Base de Données

### Commandes SQL pour vérifier les données

```sql
-- Voir tous les utilisateurs
SELECT * FROM users;

-- Voir toutes les émotions
SELECT * FROM emotions;

-- Voir toutes les alertes
SELECT * FROM alerts;

-- Voir les émotions d'un patient spécifique
SELECT * FROM emotions WHERE user_id = 1;

-- Compter les émotions par type
SELECT emotion_type, COUNT(*) as count 
FROM emotions 
GROUP BY emotion_type;

-- Voir les alertes non lues
SELECT * FROM alerts WHERE is_read = false;
```

## 8. Tests d'Erreurs

### Test 1 : Connexion avec mauvais mot de passe
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john.doe@example.com",
    "password": "wrongpassword"
  }'
```
**Résultat attendu:** 401 Unauthorized

### Test 2 : Accès sans token
```bash
curl -X GET http://localhost:8080/api/emotions
```
**Résultat attendu:** 401 Unauthorized

### Test 3 : Email déjà utilisé
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "fullName": "Jane Doe",
    "email": "john.doe@example.com",
    "password": "password123"
  }'
```
**Résultat attendu:** 400 Bad Request avec message d'erreur

## 9. Script de Test Automatisé

Créez un fichier `test-api.sh` (Linux/Mac) ou `test-api.ps1` (Windows) pour automatiser les tests.

## 10. Vérification des Logs

Surveillez les logs de l'application pour voir :
- Les requêtes SQL exécutées
- Les erreurs éventuelles
- Les alertes créées
- Les détections d'émotions

**Logs dans la console:**
```
2024-01-15 10:30:00 INFO  - Alert created for patient 1 due to 3 consecutive SAD emotions
2024-01-15 10:31:00 INFO  - Emotion detected from image for patient 1: SAD with confidence 0.85
```

## Checklist de Test

- [ ] Inscription fonctionne
- [ ] Connexion fonctionne et retourne un token
- [ ] Création d'émotion manuelle fonctionne
- [ ] Détection d'émotion depuis image fonctionne
- [ ] Récupération de l'historique fonctionne
- [ ] Système d'alerte se déclenche pour 3 SAD consécutives
- [ ] Validation des permissions (PATIENT vs DOCTOR)
- [ ] Gestion des erreurs (401, 400, 404)
- [ ] Base de données se remplit correctement

## Support

Si vous rencontrez des problèmes :
1. Vérifiez que l'application est démarrée
2. Vérifiez les logs de l'application
3. Vérifiez la connexion à la base de données MySQL
4. Vérifiez que le token JWT est valide et non expiré

