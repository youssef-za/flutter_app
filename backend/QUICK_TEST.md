# Test Rapide du Backend

## Étapes pour tester rapidement

### 1. Démarrer l'application
```bash
mvn spring-boot:run
```

### 2. Test d'inscription (copier-coller dans un terminal)

**Windows PowerShell:**
```powershell
$body = @{
    fullName = "Test User"
    email = "test@example.com"
    password = "password123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8080/api/auth/register" -Method Post -ContentType "application/json" -Body $body
```

**Linux/Mac/Windows (avec curl):**
```bash
curl -X POST http://localhost:8080/api/auth/register ^
  -H "Content-Type: application/json" ^
  -d "{\"fullName\":\"Test User\",\"email\":\"test@example.com\",\"password\":\"password123\"}"
```

### 3. Test de connexion

**PowerShell:**
```powershell
$body = @{
    email = "test@example.com"
    password = "password123"
} | ConvertTo-Json

$response = Invoke-RestMethod -Uri "http://localhost:8080/api/auth/login" -Method Post -ContentType "application/json" -Body $body
$token = $response.token
Write-Host "Token: $token"
```

**curl:**
```bash
curl -X POST http://localhost:8080/api/auth/login -H "Content-Type: application/json" -d "{\"email\":\"test@example.com\",\"password\":\"password123\"}"
```

### 4. Créer une émotion (remplacer YOUR_TOKEN)

**PowerShell:**
```powershell
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-Type" = "application/json"
}

$body = @{
    emotionType = "SAD"
    confidence = 0.85
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:8080/api/emotions" -Method Post -Headers $headers -Body $body
```

**curl:**
```bash
curl -X POST http://localhost:8080/api/emotions ^
  -H "Authorization: Bearer YOUR_TOKEN" ^
  -H "Content-Type: application/json" ^
  -d "{\"emotionType\":\"SAD\",\"confidence\":0.85}"
```

## Vérification dans MySQL

```sql
-- Voir les utilisateurs
SELECT * FROM users;

-- Voir les émotions
SELECT * FROM emotions;

-- Voir les alertes
SELECT * FROM alerts;
```

## Problèmes courants et solutions

### Erreur: "User not found"
- Vérifiez que vous avez bien créé un utilisateur via /auth/register
- Vérifiez que le token est valide

### Erreur: "No doctor available"
- Créez un utilisateur avec le rôle DOCTOR dans la base de données:
```sql
UPDATE users SET role = 'DOCTOR' WHERE id = 1;
```

### Erreur de connexion à la base de données
- Vérifiez que MySQL est démarré
- Vérifiez le port (4306 pour XAMPP)
- Vérifiez les credentials dans application.properties

