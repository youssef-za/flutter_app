# Postman Request - Login API

## Request Details

### Method
```
POST
```

### URL
```
http://localhost:8080/api/auth/login
```

### Headers
```
Content-Type: application/json
Accept: application/json
```

### Body (JSON)
```json
{
  "email": "john.doe@example.com",
  "password": "password123"
}
```

## Example Requests

### Login as Patient
```json
{
  "email": "john.doe@example.com",
  "password": "password123"
}
```

### Login as Doctor
```json
{
  "email": "jane.smith@example.com",
  "password": "doctor123"
}
```

## Expected Responses

### Success Response (200 OK)
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJqb2huLmRvZUBleGFtcGxlLmNvbSIsImlhdCI6MTYxNjIzOTAyMiwiZXhwIjoxNjE2MjQyNjIyfQ...",
  "type": "Bearer",
  "id": 1,
  "fullName": "John Doe",
  "email": "john.doe@example.com",
  "role": "PATIENT"
}
```

### Error Response - Invalid Credentials (401 Unauthorized)
```json
{
  "error": "Authentication failed",
  "message": "Invalid email or password"
}
```

### Error Response - Validation Error (400 Bad Request)
```json
{
  "message": "Validation failed",
  "errors": [
    "Email is required",
    "Password is required"
  ]
}
```

## cURL Command

### Basic Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "email": "john.doe@example.com",
    "password": "password123"
  }'
```

### Login with Token Extraction
```bash
# Login and save response
RESPONSE=$(curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "email": "john.doe@example.com",
    "password": "password123"
  }')

# Extract token (requires jq)
TOKEN=$(echo $RESPONSE | jq -r '.token')
echo "Token: $TOKEN"
```

## Postman Collection

See `Login_API.postman_collection.json` for the complete Postman collection with automatic token extraction.

## Test Script (Automatic Token Extraction)

Add this script to the **Tests** tab of your Login request:

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
            if (jsonData.fullName) {
                pm.environment.set("userFullName", jsonData.fullName);
            }
            
            // Afficher un message de confirmation dans la console
            console.log("✅ Token JWT extrait et stocké avec succès");
            console.log("Token (preview): " + jsonData.token.substring(0, 20) + "...");
            console.log("User ID: " + jsonData.id);
            console.log("User Role: " + jsonData.role);
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

## Testing Steps

1. **Start Spring Boot Application**
   - Ensure the backend is running on `http://localhost:8080`

2. **Open Postman**
   - Create a new request or import the collection

3. **Set Request Method**
   - Select `POST` from the method dropdown

4. **Enter URL**
   - `http://localhost:8080/api/auth/login`

5. **Set Headers**
   - `Content-Type: application/json`
   - `Accept: application/json`

6. **Set Body**
   - Select `raw` and `JSON` format
   - Paste the JSON body with your credentials:
   ```json
   {
     "email": "john.doe@example.com",
     "password": "password123"
   }
   ```

7. **Add Test Script (Optional but Recommended)**
   - Go to the **Tests** tab
   - Paste the test script above
   - This will automatically extract and store the JWT token

8. **Send Request**
   - Click "Send" button
   - Check the response
   - If test script is added, check the **Test Results** tab
   - The token will be stored in the `TOKEN` environment variable

## Using the Token

After login, use the stored token in other requests:

### In Authorization Header
```
Authorization: Bearer {{TOKEN}}
```

### In Pre-request Script
```javascript
var token = pm.environment.get("TOKEN");
pm.request.headers.add({
    key: "Authorization",
    value: "Bearer " + token
});
```

## Validation Rules

- **email**: Required, valid email format
- **password**: Required, minimum 6 characters (as per registration)

## Security Notes

- The endpoint is public (no authentication required)
- Credentials are sent in the request body (use HTTPS in production)
- JWT token is returned in the response
- Token should be stored securely (use environment variables in Postman)
- Token expiration is handled by the backend

## Response Fields

- **token**: JWT token string (use for authenticated requests)
- **type**: Token type (always "Bearer")
- **id**: User ID
- **fullName**: User's full name
- **email**: User's email address
- **role**: User's role (PATIENT or DOCTOR)

## Troubleshooting

### 401 Unauthorized
- Check email and password are correct
- Verify user exists in database
- Check password is not encrypted (should be plain text in request)

### 400 Bad Request
- Verify JSON format is correct
- Check all required fields are present
- Verify email format is valid

### Token Not Extracted
- Ensure test script is in the "Tests" tab
- Check that an environment is selected in Postman
- Verify response contains a "token" field
- Check Postman console for errors

