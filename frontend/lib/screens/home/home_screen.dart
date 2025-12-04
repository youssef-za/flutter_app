import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/emotion_provider.dart';
import '../../services/navigation_service.dart';
import 'tabs/patient_dashboard_tab.dart';
import 'tabs/doctor_dashboard_tab.dart';
import 'tabs/emotions_tab.dart';
import 'tabs/history_tab.dart';
import 'tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  final int? initialTab;
  
  const HomeScreen({super.key, this.initialTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab ?? 0;
  }

  void switchToHistoryTab() {
    setState(() {
      _currentIndex = 1;
    });
  }

  List<Widget> _getTabs() {
    // Check if user is patient or doctor
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final isPatient = authProvider.currentUser?.role == 'PATIENT';

    if (isPatient) {
      return [
        const PatientDashboardTab(),
        const HistoryTab(),
        const ProfileTab(),
      ];
    } else {
      // Doctor view
      return [
        const DoctorDashboardTab(),
        const HistoryTab(),
        const ProfileTab(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Monitoring'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final authProvider =
                  Provider.of<AuthProvider>(context, listen: false);
              await authProvider.logout();
              if (mounted) {
                NavigationService.logout();
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _getTabs(),
      ),
      bottomNavigationBar: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final isPatient = authProvider.currentUser?.role == 'PATIENT';
          return BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(isPatient ? Icons.dashboard : Icons.medical_services),
                label: isPatient ? 'Dashboard' : 'Dashboard',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          );
        },
      ),
    );
  }
}

