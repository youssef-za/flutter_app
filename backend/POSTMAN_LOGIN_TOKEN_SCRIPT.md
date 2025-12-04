# Postman Test Script - Extract JWT Token from Login

## Script de Test pour Extraire le Token JWT

Ce script extrait automatiquement le token JWT de la réponse de login et le stocke dans une variable d'environnement appelée `TOKEN`.

### Script Complet

```javascript
// Test script pour extraire le token JWT de la réponse de login
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

// Extraire et stocker le token JWT
if (pm.response.code === 200) {
    try {
        var jsonData = pm.response.json();
        
        // Vérifier que le token existe dans la réponse
        if (jsonData.token) {
            // Stocker le token dans la variable d'environnement TOKEN
            pm.environment.set("TOKEN", jsonData.token);
            
            // Optionnel: Stocker d'autres informations utiles
            if (jsonData.id) {
                pm.environment.set("userId", jsonData.id);
            }
            if (jsonData.email) {
                pm.environment.set("userEmail", jsonData.email);
            }
            if (jsonData.role) {
                pm.environment.set("userRole", jsonData.role);
            }
            
            // Afficher un message de confirmation dans la console
            console.log("✅ Token JWT extrait et stocké avec succès");
            console.log("Token (preview): " + jsonData.token.substring(0, 20) + "...");
        } else {
            console.error("❌ Token non trouvé dans la réponse");
            pm.expect(jsonData.token).to.exist;
        }
    } catch (error) {
        console.error("❌ Erreur lors de l'extraction du token:", error);
        throw error;
    }
} else {
    console.error("❌ La requête a échoué avec le code:", pm.response.code);
    var errorBody = pm.response.json();
    console.error("Message d'erreur:", errorBody);
}
```

### Script Simplifié (Version Minimale)

```javascript
// Version simplifiée - Extraction du token uniquement
if (pm.response.code === 200) {
    var jsonData = pm.response.json();
    pm.environment.set("TOKEN", jsonData.token);
}
```

### Script avec Gestion d'Erreurs Avancée

```javascript
// Script avec gestion d'erreurs complète
pm.test("Login successful", function () {
    pm.response.to.have.status(200);
    pm.expect(pm.response.json()).to.have.property('token');
});

// Extraire le token
var responseJson = pm.response.json();

if (responseJson && responseJson.token) {
    // Stocker le token
    pm.environment.set("TOKEN", responseJson.token);
    
    // Stocker les informations utilisateur
    if (responseJson.id) pm.environment.set("userId", responseJson.id);
    if (responseJson.email) pm.environment.set("userEmail", responseJson.email);
    if (responseJson.role) pm.environment.set("userRole", responseJson.role);
    if (responseJson.fullName) pm.environment.set("userFullName", responseJson.fullName);
    
    // Log pour debug
    console.log("Token stored successfully");
    console.log("User ID:", responseJson.id);
    console.log("User Role:", responseJson.role);
} else {
    console.error("Token not found in response");
    pm.test("Token extraction failed", function () {
        pm.expect(responseJson.token).to.exist;
    });
}
```

## Comment Utiliser

### Méthode 1: Dans Postman UI

1. **Ouvrir la requête Login** dans Postman
2. **Aller dans l'onglet "Tests"** (en bas de la requête)
3. **Coller le script** dans l'éditeur
4. **Envoyer la requête**
5. Le token sera automatiquement stocké dans la variable `TOKEN`

### Méthode 2: Dans la Collection

1. **Ouvrir la collection** dans Postman
2. **Sélectionner la requête "Login"**
3. **Aller dans l'onglet "Tests"**
4. **Coller le script**
5. **Sauvegarder la collection**

## Structure de la Réponse Attendue

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

## Utilisation du Token Stocké

Une fois le token stocké, vous pouvez l'utiliser dans d'autres requêtes :

### Dans les Headers
```
Authorization: Bearer {{TOKEN}}
```

### Dans le Pre-request Script
```javascript
var token = pm.environment.get("TOKEN");
pm.request.headers.add({
    key: "Authorization",
    value: "Bearer " + token
});
```

## Variables d'Environnement Créées

Le script stocke automatiquement :
- `TOKEN` - Le token JWT (requis)
- `userId` - L'ID de l'utilisateur (optionnel)
- `userEmail` - L'email de l'utilisateur (optionnel)
- `userRole` - Le rôle de l'utilisateur (optionnel)
- `userFullName` - Le nom complet (optionnel)

## Tests Automatiques Inclus

Le script inclut également des tests automatiques :
- ✅ Vérification du code de statut (200)
- ✅ Vérification de la présence du token
- ✅ Logs pour le débogage

## Exemple de Requête Login

**Method:** `POST`  
**URL:** `http://localhost:8080/api/auth/login`

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

## Dépannage

### Le token n'est pas stocké

1. Vérifier que la réponse est 200
2. Vérifier que la réponse contient un champ `token`
3. Vérifier que l'environnement est sélectionné dans Postman
4. Vérifier la console Postman pour les erreurs

### Le token est vide

1. Vérifier que le backend retourne bien un token
2. Vérifier le format de la réponse JSON
3. Vérifier les logs dans la console Postman

## Notes

- Le script fonctionne avec les **environnements Postman**
- Assurez-vous qu'un environnement est **sélectionné** avant d'exécuter la requête
- Le token est stocké de manière **persistante** dans l'environnement
- Vous pouvez utiliser `{{TOKEN}}` dans n'importe quelle requête de la collection

