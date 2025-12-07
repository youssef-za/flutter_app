# Medical Emotion Monitoring System - Complete Features Documentation

## 📱 Application Overview

**Medical Emotion Monitoring System** is a comprehensive healthcare application designed to monitor and track patient emotions using facial recognition technology. The system consists of a Spring Boot backend and a Flutter mobile application, providing a complete solution for emotion tracking, patient management, and medical reporting.

---

## 🎯 Core Features

### 1. **Authentication & Security**

#### User Registration
- ✅ **Role-based registration**: Users can register as either **Patient** or **Doctor**
- ✅ **Password validation**: Enforces strong password requirements:
  - Minimum 8 characters
  - At least one uppercase letter
  - At least one lowercase letter
  - At least one number
  - At least one special character
- ✅ **Email validation**: Client-side and server-side email format validation
- ✅ **Account creation**: Secure account creation with encrypted password storage

#### User Login
- ✅ **JWT-based authentication**: Secure token-based authentication
- ✅ **Account lockout protection**: Prevents brute-force attacks
  - Account locks after X failed login attempts (configurable)
  - Automatic unlock after lock duration expires
  - Failed attempt tracking and logging
- ✅ **Auto-login**: Remembers user session for seamless app restart
- ✅ **Secure token storage**: JWT tokens stored securely using `flutter_secure_storage`

#### Session Management
- ✅ **Token refresh**: Automatic token refresh mechanism (planned)
- ✅ **Session persistence**: Maintains user session across app restarts
- ✅ **Secure logout**: Clears all authentication data and tokens

---

### 2. **Patient Features**

#### Patient Dashboard
- ✅ **Current emotion display**: Shows the most recent detected emotion
  - Emotion type (HAPPY, SAD, ANGRY, FEAR, SURPRISE, NEUTRAL)
  - Confidence percentage
  - Timestamp of detection
- ✅ **Emotion capture**: Quick access button to capture new emotion
- ✅ **Emotion statistics widget**: 
  - Bar chart showing frequency of each emotion type
  - Most frequent emotion highlight
  - Visual representation with color-coded emotions
- ✅ **Weekly statistics widget**:
  - Line chart showing emotion trends over the last 7 days
  - Daily emotion count
  - Average emotions per day
- ✅ **Stress level indicator**:
  - Calculates stress level based on negative emotions
  - Visual progress bar with color coding:
    - Green (0-30%): Low stress
    - Yellow (31-50%): Moderate stress
    - Orange (51-70%): High stress
    - Red (71-100%): Very high stress
  - Helpful recommendations when stress is high
- ✅ **Tips widget**: Daily tips for emotional well-being
  - Random tips displayed
  - Context-aware suggestions based on emotion patterns
- ✅ **Welcome message**: Personalized greeting with user's name
- ✅ **Pull-to-refresh**: Refresh data by pulling down

#### Emotion Detection
- ✅ **Camera-based detection**: 
  - Uses device camera to capture facial images
  - Real-time image preview
  - High-quality image capture
- ✅ **Multiple API support**: 
  - **Luxand API** (Primary - 500 free requests/month)
  - **HuggingFace API** (Fallback - vision model)
  - **EdenAI API** (Alternative)
  - Automatic fallback if primary API fails
- ✅ **Base64 image encoding**: Secure image transmission
- ✅ **Confidence scoring**: Each detection includes confidence percentage
- ✅ **Manual emotion entry**: Option to manually record emotions

#### Emotion History
- ✅ **Complete history view**: All recorded emotions with timestamps
- ✅ **Charts and graphs**: 
  - Line charts for trends
  - Bar charts for frequency
  - Pie charts for distribution
- ✅ **Date sorting**: Sort emotions by date (newest/oldest first)
- ✅ **Pagination**: Efficient loading of large emotion datasets
- ✅ **Filter by emotion type**: Filter history by specific emotions
- ✅ **Search functionality**: Search emotions by date or type

#### Patient Profile
- ✅ **Profile information**:
  - Full name
  - Email address
  - Age
  - Gender (MALE, FEMALE, OTHER)
  - Profile picture (base64 encoded)
  - Last connected date
- ✅ **Profile editing**: 
  - Edit full name
  - Edit email address
  - Update profile picture
- ✅ **Password management**: 
  - Change password functionality
  - Current password verification
  - New password validation

---

### 3. **Doctor Features**

#### Doctor Dashboard
- ✅ **Patient list**: Complete list of all assigned patients
- ✅ **Patient overview statistics**:
  - Total number of patients
  - Number of active patients (with recent emotions)
- ✅ **Real-time alerts**: 
  - Critical emotion alerts (e.g., high stress, frequent sadness)
  - Unread alerts counter
  - Alert notifications with patient names
  - Mark alerts as read
- ✅ **Patient search**: 
  - Search by patient name
  - Search by email address
  - Real-time search filtering
- ✅ **Advanced filtering**:
  - Filter by time period:
    - Today
    - This week
    - This month
    - All time
  - Filter by emotion type
- ✅ **Patient sorting**:
  - Sort by most recent emotion
  - Sort by most critical emotions
  - Sort by patient name (A-Z)
  - Sort by last activity date
- ✅ **Patient cards**: 
  - Patient name and email
  - Latest emotion with timestamp
  - Emotion confidence level
  - Quick access to patient details
- ✅ **Pull-to-refresh**: Refresh patient data

#### Patient Detail Screen
- ✅ **Complete patient information**:
  - Full profile details
  - Contact information
  - Profile picture
  - Last connected date
- ✅ **Emotion history for patient**:
  - Complete emotion timeline
  - Charts and statistics
  - Emotion frequency analysis
- ✅ **Patient notes**:
  - Add notes for each patient
  - Edit existing notes
  - Delete notes
  - View all notes with timestamps
  - Notes are doctor-specific
- ✅ **Patient tags**:
  - Tag patients with labels:
    - "Urgent"
    - "Follow-up"
    - "Stable"
    - Custom tags
  - Add/remove tags
  - Visual tag indicators
- ✅ **Edit patient information**:
  - Update patient name
  - Update patient email
  - Update patient age
  - Update patient gender
  - Only doctors can edit patient info
- ✅ **PDF report generation**:
  - Generate comprehensive patient reports
  - Includes:
    - Patient information
    - Emotion histogram
    - Weekly trend chart
    - All doctor notes
    - Recommendations
  - Download and share PDF reports
  - Professional report formatting

#### Patient Management
- ✅ **Assign patients**: Doctors can assign patients to their care
- ✅ **Unassign patients**: Remove patients from doctor's list
- ✅ **View assigned patients**: See all patients under doctor's care
- ✅ **Patient statistics**: View aggregated statistics for each patient

#### Doctor Profile
- ✅ **Profile information**:
  - Full name
  - Email address
  - Specialty (medical specialty field)
  - List of assigned patients
- ✅ **Profile editing**: 
  - Edit full name
  - Edit email address
  - Update specialty
- ✅ **Password management**: 
  - Change password functionality
  - Secure password updates

---

### 4. **Emotion Detection System**

#### Supported Emotions
- ✅ **HAPPY**: Positive, joyful emotions
- ✅ **SAD**: Negative, melancholic emotions
- ✅ **ANGRY**: Aggressive, frustrated emotions
- ✅ **FEAR**: Anxious, scared emotions
- ✅ **SURPRISE**: Shocked, amazed emotions
- ✅ **NEUTRAL**: Calm, balanced emotions

#### Detection Methods
- ✅ **AI-powered facial recognition**: 
  - Uses advanced vision models
  - Real-time emotion analysis
  - High accuracy detection
- ✅ **Multiple API providers**: 
  - Automatic failover between APIs
  - Configurable API selection
  - API key management
- ✅ **Confidence scoring**: Each detection includes confidence level (0-100%)

#### Detection Features
- ✅ **Image preprocessing**: Optimized image quality before analysis
- ✅ **Error handling**: Graceful handling of API failures
- ✅ **Mock mode**: Fallback to mock data when APIs are unavailable
- ✅ **Logging**: Comprehensive logging for debugging

---

### 5. **Statistics & Analytics**

#### Patient Statistics
- ✅ **Emotion frequency**: Count of each emotion type
- ✅ **Weekly trends**: Emotion patterns over 7 days
- ✅ **Stress level calculation**: 
  - Based on negative emotions (SAD, ANGRY, FEAR)
  - Percentage-based stress indicator
  - Color-coded visualization
- ✅ **Average emotions per day**: Statistical analysis
- ✅ **Emotion distribution**: Visual charts and graphs

#### Doctor Analytics
- ✅ **Patient overview**: Total and active patient counts
- ✅ **Alert statistics**: Number of critical alerts
- ✅ **Patient activity**: Recent activity tracking
- ✅ **Emotion summary**: Aggregated emotion data across all patients

---

### 6. **User Interface & Design**

#### Material Design 3
- ✅ **Modern UI**: Fully redesigned with Material 3 guidelines
- ✅ **Color scheme**: 
  - Dynamic color system
  - Primary, secondary, and accent colors
  - Surface and container colors
- ✅ **Typography**: 
  - Refined text styles
  - Consistent font hierarchy
  - Improved readability
- ✅ **Buttons**: 
  - Elevated buttons
  - Filled and outlined variants
  - Rounded corners (16px radius)
  - Proper elevation and shadows
- ✅ **Cards**: 
  - Modern card design
  - Rounded corners (20px radius)
  - Surface container colors
  - Optional gradients
- ✅ **AppBar**: 
  - Modern AppBar design
  - Consistent styling
  - Action buttons
- ✅ **Navigation**: 
  - Material 3 NavigationBar
  - Smooth animations
  - Icon-based navigation
  - Selected state indicators

#### Dark Mode / Light Mode
- ✅ **Theme switching**: Toggle between light and dark themes
- ✅ **System preference**: Automatic theme based on system settings
- ✅ **Persistent theme**: Remembers user's theme preference
- ✅ **Consistent colors**: All colors adapt to theme mode

#### Animations
- ✅ **Page transitions**: 
  - Fade transitions
  - Slide transitions
  - Custom route animations
- ✅ **Loading states**: 
  - Smooth loading indicators
  - Skeleton screens
- ✅ **Widget animations**: 
  - Fade-in animations
  - Slide-in animations
  - Animated cards
- ✅ **Pull-to-refresh**: Smooth refresh animations

#### Responsive Design
- ✅ **Adaptive layouts**: Works on different screen sizes
- ✅ **Orientation support**: Portrait and landscape modes
- ✅ **Touch-friendly**: Proper touch target sizes
- ✅ **Accessibility**: Screen reader support

---

### 7. **Offline Capabilities** (Planned)

- 🔄 **Local storage**: 
  - Hive database integration
  - Shared preferences
  - Last detected emotion caching
- 🔄 **Offline mode**: 
  - View cached emotions
  - View cached profile
  - View cached history
  - Sync when online
- 🔄 **Session persistence**: 
  - User session stored locally
  - Auto-login from cache
  - Secure local storage

---

### 8. **Backend API Features**

#### Authentication Endpoints
- ✅ `POST /api/auth/register` - User registration
- ✅ `POST /api/auth/login` - User login
- ✅ `POST /api/auth/logout` - User logout (planned)

#### Emotion Endpoints
- ✅ `POST /api/emotions` - Create emotion record
- ✅ `POST /api/emotions/detect` - Detect emotion from image
- ✅ `GET /api/emotions` - Get all emotions for current user
- ✅ `GET /api/emotions/{id}` - Get specific emotion
- ✅ `GET /api/emotions/patient/{patientId}` - Get patient emotions (doctor only)
- ✅ `GET /api/emotions/patient/{patientId}/statistics` - Get patient statistics

#### User Endpoints
- ✅ `GET /api/users/{id}` - Get user by ID
- ✅ `GET /api/users/email/{email}` - Get user by email
- ✅ `GET /api/users` - Get all users (doctor only)
- ✅ `GET /api/users/patients` - Get all patients (doctor only)
- ✅ `PUT /api/users/profile` - Update user profile
- ✅ `PUT /api/users/password` - Change password
- ✅ `POST /api/users/patients/{patientId}/assign` - Assign patient to doctor
- ✅ `DELETE /api/users/patients/{patientId}/assign` - Unassign patient
- ✅ `PUT /api/users/patients/{patientId}` - Update patient info (doctor only)

#### Patient Note Endpoints
- ✅ `POST /api/patient-notes` - Create patient note
- ✅ `GET /api/patient-notes/patient/{patientId}` - Get all notes for patient
- ✅ `PUT /api/patient-notes/{id}` - Update patient note
- ✅ `DELETE /api/patient-notes/{id}` - Delete patient note

#### Patient Tag Endpoints
- ✅ `POST /api/patient-tags` - Add patient tag
- ✅ `GET /api/patient-tags/patient/{patientId}` - Get all tags for patient
- ✅ `DELETE /api/patient-tags/{id}` - Remove patient tag

#### Alert Endpoints
- ✅ `GET /api/alerts` - Get all alerts for current user
- ✅ `GET /api/alerts/unread` - Get unread alerts
- ✅ `PUT /api/alerts/{id}/read` - Mark alert as read

---

### 9. **Security Features**

#### Password Security
- ✅ **Strong password requirements**: Enforced validation rules
- ✅ **Password hashing**: BCrypt encryption
- ✅ **Password change**: Secure password update mechanism

#### Account Security
- ✅ **Account lockout**: Protection against brute-force attacks
- ✅ **Failed login tracking**: Monitors and logs failed attempts
- ✅ **Session management**: Secure JWT token handling
- ✅ **Role-based access control**: Different permissions for patients and doctors

#### Data Security
- ✅ **JWT authentication**: Secure token-based authentication
- ✅ **HTTPS support**: Secure communication (when deployed)
- ✅ **Input validation**: Server-side validation for all inputs
- ✅ **SQL injection protection**: Parameterized queries
- ✅ **XSS protection**: Input sanitization

---

### 10. **Additional Features**

#### PDF Report Generation
- ✅ **Comprehensive reports**: 
  - Patient information
  - Emotion histogram
  - Weekly trend chart
  - Doctor notes
  - Recommendations
- ✅ **Professional formatting**: 
  - Clean layout
  - Color-coded charts
  - Proper typography
- ✅ **Download and share**: 
  - Save to device
  - Share via other apps
  - Print support

#### Search & Filter
- ✅ **Patient search**: Real-time search by name or email
- ✅ **Emotion filtering**: Filter by emotion type
- ✅ **Date filtering**: Filter by time period
- ✅ **Sorting options**: Multiple sorting criteria

#### Notifications & Alerts
- ✅ **Real-time alerts**: Critical emotion notifications
- ✅ **Alert management**: Mark as read, view all alerts
- ✅ **Alert types**: 
  - High stress alerts
  - Frequent negative emotions
  - Critical patient status

#### Data Visualization
- ✅ **Charts and graphs**: 
  - Bar charts
  - Line charts
  - Pie charts
  - Progress bars
- ✅ **Color coding**: Visual emotion representation
- ✅ **Interactive charts**: Tap to view details

---

## 🛠️ Technical Stack

### Backend
- **Framework**: Spring Boot 3.2.0
- **Database**: MySQL
- **Authentication**: JWT (JSON Web Tokens)
- **Security**: Spring Security
- **ORM**: JPA/Hibernate
- **Build Tool**: Maven
- **Language**: Java 17+

### Frontend
- **Framework**: Flutter 3.38.3
- **Language**: Dart 3.0.0+
- **State Management**: Provider
- **HTTP Client**: Dio
- **Charts**: fl_chart
- **PDF Generation**: pdf, printing
- **Storage**: flutter_secure_storage, shared_preferences
- **Camera**: camera, image_picker
- **UI**: Material Design 3

### Emotion Detection APIs
- **Luxand API**: Primary API (500 free requests/month)
- **HuggingFace API**: Fallback API (vision model)
- **EdenAI API**: Alternative API

---

## 📊 Database Schema

### Core Entities
- **User**: Patients and doctors
- **Emotion**: Emotion records
- **Alert**: System alerts
- **PatientNote**: Doctor's notes for patients
- **PatientTag**: Tags for patient organization
- **LoginAttempt**: Failed login tracking

### Relationships
- User → Emotion (One-to-Many)
- Doctor → Patient (Many-to-Many)
- Doctor → PatientNote (One-to-Many)
- Doctor → PatientTag (One-to-Many)

---

## 🚀 Getting Started

### Prerequisites
- Java 17+
- Maven 3.9+
- Flutter 3.38.3+
- MySQL 8.0+
- Android Studio / VS Code

### Backend Setup
```bash
cd backend
mvn clean install
mvn spring-boot:run
```

### Frontend Setup
```bash
cd frontend
flutter pub get
flutter run
```

---

## 📱 Supported Platforms

- ✅ **Android**: Full support
- ✅ **iOS**: Full support (when configured)
- ✅ **Web**: Partial support
- ✅ **Windows**: Partial support
- ✅ **Linux**: Partial support
- ✅ **macOS**: Partial support

---

## 🔮 Future Enhancements

### Planned Features
- 🔄 **Refresh token system**: Extended session management
- 🔄 **Offline mode**: Complete offline functionality
- 🔄 **Push notifications**: Real-time notifications
- 🔄 **Video emotion detection**: Continuous emotion monitoring
- 🔄 **Multi-language support**: Internationalization
- 🔄 **Advanced analytics**: Machine learning insights
- 🔄 **Telemedicine integration**: Video consultations
- 🔄 **Medication tracking**: Medication reminders
- 🔄 **Appointment scheduling**: Doctor-patient appointments

---

## 📝 Notes

- All emotion detection APIs require API keys (some are free)
- The application is designed for healthcare use cases
- Patient data is sensitive and should be handled according to HIPAA/GDPR regulations
- The system supports role-based access control
- All API endpoints are protected with JWT authentication

---

## 📞 Support

For issues, questions, or contributions, please refer to the project repository or contact the development team.

---

**Last Updated**: 2024
**Version**: 1.0.0
**License**: [Specify License]


