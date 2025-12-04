class AppConfig {
  // API Configuration
  // Changez cette URL si votre backend est sur un autre serveur
  // Pour un appareil physique Android, utilisez l'IP de votre PC au lieu de localhost
  // Exemple: 'http://192.168.1.100:8080/api'
  static const String baseUrl = 'http://192.168.1.107:8080/api';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);
  
  // Storage Keys
  static const String tokenKey = 'token';
  static const String userKey = 'user';
  
  // App Info
  static const String appName = 'Emotion Monitoring';
  static const String appVersion = '1.0.0';
  
  // Debug Mode (set to false in production)
  static const bool debugMode = true;
}

