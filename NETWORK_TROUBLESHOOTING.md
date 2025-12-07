# Network Troubleshooting Guide

## Connection Timeout Error Fix

### Problem
Flutter app shows: `DioExceptionType.connectionTimeout` when trying to connect to Spring Boot backend.

### Solutions Applied

#### 1. ✅ Fixed baseUrl in Flutter
- **File**: `frontend/lib/config/app_config.dart`
- **Change**: Added `/api` to baseUrl (backend uses `/api` as context-path)
- **Before**: `http://192.168.100.13:8080`
- **After**: `http://192.168.100.13:8080/api`

#### 2. ✅ Increased Timeouts
- **File**: `frontend/lib/config/app_config.dart`
- **Change**: Increased from 10 seconds to 30 seconds
- **Reason**: Network connections on mobile devices can be slower

#### 3. ✅ Backend Network Configuration
- **File**: `backend/src/main/resources/application.properties`
- **Change**: Added `server.address=0.0.0.0` to listen on all network interfaces
- **Reason**: Allows connections from other devices on the network

### Verification Steps

#### Step 1: Verify Backend is Running
```bash
# Check if backend is running on port 8080
netstat -an | findstr :8080
```

#### Step 2: Test Backend from Browser
Open in browser on your PC:
```
http://localhost:8080/api/auth/register
```

If this works, the backend is running correctly.

#### Step 3: Test Backend from Phone Browser
On your phone (connected to same WiFi), open:
```
http://192.168.100.13:8080/api/auth/register
```

If this works, the network connection is fine.

#### Step 4: Check Firewall
Windows Firewall might be blocking port 8080:

1. Open Windows Defender Firewall
2. Click "Advanced settings"
3. Click "Inbound Rules" → "New Rule"
4. Select "Port" → Next
5. Select "TCP" and enter port "8080"
6. Select "Allow the connection"
7. Apply to all profiles
8. Name it "Spring Boot Backend"

#### Step 5: Verify IP Address
Make sure your PC's IP is actually `192.168.100.13`:

**Windows:**
```powershell
ipconfig
```
Look for "IPv4 Address" under your WiFi adapter.

**Linux/Mac:**
```bash
ifconfig
# or
ip addr
```

#### Step 6: Check WiFi Network
- Phone and PC must be on the **same WiFi network**
- Not on mobile data
- Not on different networks

### Common Issues

#### Issue 1: Backend only listens on localhost
**Solution**: Already fixed with `server.address=0.0.0.0`

#### Issue 2: Wrong IP address
**Solution**: Update `baseUrl` in `app_config.dart` with correct IP

#### Issue 3: Firewall blocking
**Solution**: Add firewall rule (see Step 4 above)

#### Issue 4: Backend not running
**Solution**: Start backend with:
```bash
cd backend
mvn spring-boot:run
```

#### Issue 5: Port already in use
**Solution**: Change port in `application.properties` or stop other service using port 8080

### Testing Connection

#### Test 1: From PC Browser
```
http://192.168.100.13:8080/api/auth/register
```
Should show error (expected - needs POST), but confirms backend is reachable.

#### Test 2: From Phone Browser
```
http://192.168.100.13:8080/api/auth/register
```
Should show same error, confirming network connectivity.

#### Test 3: Using curl (if available)
```bash
curl -X POST http://192.168.100.13:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{"fullName":"Test","email":"test@test.com","password":"Test123!@#","role":"PATIENT"}'
```

### Flutter App Configuration

#### Current Settings:
```dart
// frontend/lib/config/app_config.dart
static const String baseUrl = 'http://192.168.100.13:8080/api';
static const Duration connectTimeout = Duration(seconds: 30);
static const Duration receiveTimeout = Duration(seconds: 30);
```

#### If Still Having Issues:

1. **Check Debug Logs**: Enable debug mode in `app_config.dart`
2. **Test with Postman**: Verify backend works from Postman first
3. **Check Network Permissions**: Ensure AndroidManifest.xml has internet permission
4. **Try Different Network**: Test on different WiFi network
5. **Use Hotspot**: Create WiFi hotspot on PC and connect phone to it

### Android Network Security Config

If using HTTPS or having certificate issues, you may need to add network security config:

**File**: `frontend/android/app/src/main/res/xml/network_security_config.xml`
```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">192.168.100.13</domain>
    </domain-config>
</network-security-config>
```

**File**: `frontend/android/app/src/main/AndroidManifest.xml`
Add inside `<application>`:
```xml
<application
    android:usesCleartextTraffic="true"
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

### Quick Checklist

- [ ] Backend is running (`mvn spring-boot:run`)
- [ ] Backend listens on `0.0.0.0:8080` (not just localhost)
- [ ] IP address is correct (`192.168.100.13`)
- [ ] Phone and PC on same WiFi network
- [ ] Firewall allows port 8080
- [ ] baseUrl includes `/api`: `http://192.168.100.13:8080/api`
- [ ] Timeouts are 30 seconds
- [ ] Can access backend from phone browser
- [ ] AndroidManifest.xml has internet permission

### Still Not Working?

1. **Restart Backend**: Stop and restart Spring Boot
2. **Restart Flutter App**: Hot restart (not just hot reload)
3. **Check Logs**: Look at both backend and Flutter logs
4. **Try Different Port**: Change to 8081 or 3000
5. **Use ngrok**: For testing over internet (not recommended for production)

### Example Working Configuration

**Backend** (`application.properties`):
```properties
server.port=8080
server.address=0.0.0.0
server.servlet.context-path=/api
```

**Flutter** (`app_config.dart`):
```dart
static const String baseUrl = 'http://192.168.100.13:8080/api';
static const Duration connectTimeout = Duration(seconds: 30);
static const Duration receiveTimeout = Duration(seconds: 30);
```


