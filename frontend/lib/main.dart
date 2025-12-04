import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_routes.dart';
import 'config/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/emotion_provider.dart';
import 'providers/alert_provider.dart';
import 'providers/patient_provider.dart';
import 'services/navigation_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/camera/camera_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => EmotionProvider()),
        ChangeNotifierProvider(create: (_) => AlertProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
      ],
      child: MaterialApp(
        title: 'Emotion Monitoring',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        navigatorKey: NavigationService.navigatorKey,
        initialRoute: AppRoutes.splash,
        routes: _buildRoutes(),
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  /// Build all named routes
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
      AppRoutes.splash: (context) => const SplashScreen(),
      AppRoutes.login: (context) => const LoginScreen(),
      AppRoutes.register: (context) => const RegisterScreen(),
      AppRoutes.home: (context) => const HomeScreen(),
      AppRoutes.emotionCapture: (context) => const CameraScreen(),
    };
  }

  /// Generate routes dynamically (for routes with arguments)
  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.patientDashboard:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(initialTab: 0),
          settings: settings,
        );
      case AppRoutes.doctorDashboard:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(initialTab: 0),
          settings: settings,
        );
      case AppRoutes.emotionHistory:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(initialTab: 1),
          settings: settings,
        );
      default:
        return null;
    }
  }
}
