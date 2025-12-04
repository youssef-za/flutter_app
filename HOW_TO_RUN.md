# 🚀 How to Run the Project

This guide explains how to run both the **Backend (Spring Boot)** and **Frontend (Flutter)** applications.

---

## 📋 Prerequisites

- ✅ **Java 17+** (You have Java 23 - compatible)
- ✅ **Maven/mvnd** (You have mvnd 1.0.3 - compatible)
- ✅ **Flutter SDK 3.38.3** (You have this version)
- ✅ **MySQL Database** (Required for backend)

---

## 🔧 Part 1: Backend (Spring Boot)

### Step 1: Navigate to Backend Directory

**Git Bash:**
```bash
cd ~/Desktop/flutter_app/backend
```

**PowerShell:**
```powershell
cd C:\Users\Dell\Desktop\flutter_app\backend
```

### Step 2: Configure Database

Make sure MySQL is running and update `src/main/resources/application.properties` with your database credentials.

### Step 3: Run Backend

**Option A: Using Script (Recommended)**

**Git Bash:**
```bash
./run-backend.sh
```

**PowerShell:**
```powershell
.\run-backend-simple.ps1
```

**Option B: Manual Command**

**Git Bash:**
```bash
# Add mvnd to PATH
export PATH="$PATH:/c/Users/Dell/Desktop/maven-mvnd-1.0.3-windows-amd64/maven-mvnd-1.0.3-windows-amd64/bin"

# Run backend
mvnd spring-boot:run
```

**PowerShell:**
```powershell
# Add mvnd to PATH
$mvndPath = "C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\bin"
$env:Path += ";$mvndPath"

# Run backend
mvnd spring-boot:run
```

### Step 4: Verify Backend

Once started, the backend will be available at:
- **Base URL**: `http://localhost:8080`
- **API Base**: `http://localhost:8080/api`
- **Health Check**: `http://localhost:8080/api/auth/register` (POST)

---

## 📱 Part 2: Frontend (Flutter)

### Step 1: Navigate to Frontend Directory

**Git Bash:**
```bash
cd ~/Desktop/flutter_app/frontend
```

**PowerShell:**
```powershell
cd C:\Users\Dell\Desktop\flutter_app\frontend
```

### Step 2: Install Dependencies

```bash
flutter pub get
```

### Step 3: Run Frontend

**Option A: Run on Connected Device/Emulator**

```bash
# List available devices
flutter devices

# Run on specific device
flutter run

# Or run on a specific device
flutter run -d <device-id>
```

**Option B: Run on Web (if configured)**

```bash
flutter run -d chrome
```

**Option C: Run on Windows Desktop**

```bash
flutter run -d windows
```

### Step 4: Verify Frontend

- The app will launch on your selected device/emulator
- Default API URL: `http://localhost:8080/api` (configured in `lib/config/app_config.dart`)

---

## 🎯 Quick Start (Both Backend & Frontend)

### Terminal 1: Backend

**Git Bash:**
```bash
cd ~/Desktop/flutter_app/backend
export PATH="$PATH:/c/Users/Dell/Desktop/maven-mvnd-1.0.3-windows-amd64/maven-mvnd-1.0.3-windows-amd64/bin"
mvnd spring-boot:run
```

**PowerShell:**
```powershell
cd C:\Users\Dell\Desktop\flutter_app\backend
$mvndPath = "C:\Users\Dell\Desktop\maven-mvnd-1.0.3-windows-amd64\maven-mvnd-1.0.3-windows-amd64\bin"
$env:Path += ";$mvndPath"
mvnd spring-boot:run
```

### Terminal 2: Frontend

**Git Bash/PowerShell:**
```bash
cd ~/Desktop/flutter_app/frontend
flutter pub get
flutter run
```

---

## 🔍 Troubleshooting

### Backend Issues

**Problem: "No plugin found for prefix 'spring-boot'"**
- **Solution**: Make sure you're in the `backend/` directory where `pom.xml` exists

**Problem: "Maven not found"**
- **Solution**: Add mvnd to PATH or use the full path to `mvnd.exe`

**Problem: "Port 8080 already in use"**
- **Solution**: Stop the process using port 8080 or change the port in `application.properties`

### Frontend Issues

**Problem: "Flutter SDK not found"**
- **Solution**: Make sure Flutter is in your PATH or use the full path

**Problem: "No devices found"**
- **Solution**: Start an emulator or connect a physical device

**Problem: "API connection failed"**
- **Solution**: Make sure the backend is running on `http://localhost:8080`

---

## 📝 Configuration Files

### Backend Configuration
- `backend/src/main/resources/application.properties` - Database and server settings

### Frontend Configuration
- `frontend/lib/config/app_config.dart` - API base URL and app settings

---

## 🛑 Stopping the Applications

- **Backend**: Press `Ctrl+C` in the terminal running the backend
- **Frontend**: Press `Ctrl+C` in the terminal running Flutter, or press `q` in the Flutter console

---

## ✅ Verification Checklist

Before running, make sure:

- [ ] MySQL database is running
- [ ] Database credentials are correct in `application.properties`
- [ ] Backend can start without errors
- [ ] Flutter SDK is properly installed
- [ ] Frontend dependencies are installed (`flutter pub get`)
- [ ] A device/emulator is available for Flutter

---

## 🎉 Success Indicators

**Backend is running when you see:**
```
Started EmotionMonitoringApplication in X.XXX seconds
```

**Frontend is running when:**
- The app launches on your device/emulator
- You can see the login/register screen

---

## 📚 Additional Resources

- Backend Quick Start: `backend/QUICK_START.md`
- Frontend Navigation: `frontend/NAVIGATION_SYSTEM.md`
- API Testing: `backend/POSTMAN_REGISTER_API.md`

