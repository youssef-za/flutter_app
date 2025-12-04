/// Centralized route definitions for the application
class AppRoutes {
  // Root
  static const String splash = '/';
  
  // Authentication
  static const String login = '/login';
  static const String register = '/register';
  
  // Main
  static const String home = '/home';
  
  // Patient Screens
  static const String patientDashboard = '/home/patient-dashboard';
  
  // Doctor Screens
  static const String doctorDashboard = '/home/doctor-dashboard';
  
  // Emotion
  static const String emotionCapture = '/emotion/capture';
  static const String emotionHistory = '/emotion/history';
  
  // Home Tabs (internal navigation)
  static const String historyTab = '/home/history';
  static const String profileTab = '/home/profile';
  
  // Profile routes
  static const String editProfile = '/profile/edit';
  static const String changePassword = '/profile/change-password';
  
  // Patient detail route (for doctors)
  static const String patientDetail = '/patient/detail';
}
