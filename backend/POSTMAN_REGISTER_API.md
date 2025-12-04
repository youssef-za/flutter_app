# Postman Request - Register API

## Request Details

### Method
```
POST
```

### URL
```
http://localhost:8080/api/auth/register
```

### Headers
```
Content-Type: application/json
Accept: application/json
```

### Body (JSON)
```json
{
  "fullName": "John Doe",
  "email": "john.doe@example.com",
  "password": "password123",
  "role": "PATIENT"
}
```

## Example Requests

### Register as Patient
```json
{
  "fullName": "John Doe",
  "email": "john.doe@example.com",
  "password": "password123",
  "role": "PATIENT"
}
```

### Register as Doctor
```json
{
  "fullName": "Dr. Jane Smith",
  "email": "jane.smith@example.com",
  "password": "doctor123",
  "role": "DOCTOR"
}
```

### Register without Role (defaults to PATIENT)
```json
{
  "fullName": "Test User",
  "email": "test@example.com",
  "password": "test123"
}
```

## Expected Responses

### Success Response (201 Created)
```json
{
  "id": 1,
  "fullName": "John Doe",
  "email": "john.doe@example.com",
  "role": "PATIENT",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### Error Response - Email Already Exists (400 Bad Request)
```json
{
  "message": "Email already exists"
}
```

### Error Response - Validation Error (400 Bad Request)
```json
{
  "message": "Validation failed",
  "errors": [
    "Full name is required",
    "Email should be valid",
    "Password must be at least 6 characters"
  ]
}
```

## cURL Command

### Register as Patient
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "fullName": "John Doe",
    "email": "john.doe@example.com",
    "password": "password123",
    "role": "PATIENT"
  }'
```

### Register as Doctor
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -d '{
    "fullName": "Dr. Jane Smith",
    "email": "jane.smith@example.com",
    "password": "doctor123",
    "role": "DOCTOR"
  }'
```

## Postman Collection JSON

See `Register_API.postman_collection.json` for the complete Postman collection.

## Testing Steps

1. **Start Spring Boot Application**
   - Ensure the backend is running on `http://localhost:8080`

2. **Open Postman**
   - Create a new request or import the collection

3. **Set Request Method**
   - Select `POST` from the method dropdown

4. **Enter URL**
   - `http://localhost:8080/api/auth/register`

5. **Set Headers**
   - `Content-Type: application/json`
   - `Accept: application/json`

6. **Set Body**
   - Select `raw` and `JSON` format
   - Paste the JSON body with your test data

7. **Send Request**
   - Click "Send" button
   - Check the response

## Validation Rules

- **fullName**: Required, 2-100 characters
- **email**: Required, valid email format, unique
- **password**: Required, minimum 6 characters
- **role**: Optional, defaults to "PATIENT" if not provided. Must be "PATIENT" or "DOCTOR" if provided

## Notes

- The endpoint is public (no authentication required)
- Email must be unique in the system
- Password is automatically encrypted using BCrypt
- JWT token is returned in the response for immediate authentication
- Role defaults to PATIENT if not specified

