import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/patient_provider.dart';
import '../../../providers/alert_provider.dart';
import '../../../providers/emotion_provider.dart';
import '../../../models/user_model.dart';
import '../../../models/emotion_model.dart';
import '../../../models/alert_model.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/emotion_chart.dart';

class DoctorDashboardTab extends StatefulWidget {
  const DoctorDashboardTab({super.key});

  @override
  State<DoctorDashboardTab> createState() => _DoctorDashboardTabState();
}

class _DoctorDashboardTabState extends State<DoctorDashboardTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      final doctorId = authProvider.currentUser!.id;
      
      final patientProvider = Provider.of<PatientProvider>(context, listen: false);
      final alertProvider = Provider.of<AlertProvider>(context, listen: false);
      
      await Future.wait([
        patientProvider.loadPatients(),
        alertProvider.loadAlertsByDoctorId(doctorId),
        alertProvider.loadUnreadAlertsByDoctorId(doctorId),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Section
            _buildWelcomeSection(colorScheme),
            const SizedBox(height: 20),

            // Alerts Section
            Consumer<AlertProvider>(
              builder: (context, alertProvider, _) {
                return _buildAlertsSection(alertProvider, colorScheme);
              },
            ),
            const SizedBox(height: 20),

            // Statistics Overview
            Consumer<PatientProvider>(
              builder: (context, patientProvider, _) {
                return _buildStatisticsOverview(patientProvider, colorScheme);
              },
            ),
            const SizedBox(height: 20),

            // Patients List
            _buildPatientsSection(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(ColorScheme colorScheme) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final userName = authProvider.currentUser?.fullName ?? 'Doctor';
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withOpacity(0.1),
                  colorScheme.secondary.withOpacity(0.05),
                ],
              ),
            ),
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.medical_services_rounded,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Dr. ${userName.split(' ').first}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Monitor your patients\' emotional well-being',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlertsSection(AlertProvider alertProvider, ColorScheme colorScheme) {
    if (alertProvider.isLoading && alertProvider.unreadAlerts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications_active, color: Colors.red),
                    const SizedBox(width: 8),
                    const Text(
                      'Alerts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (alertProvider.unreadCount > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${alertProvider.unreadCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (alertProvider.unreadAlerts.isEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No new alerts',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              ...alertProvider.unreadAlerts.take(3).map((alert) {
                return _buildAlertCard(alert, colorScheme);
              }).toList(),
            if (alertProvider.unreadAlerts.length > 3)
              TextButton(
                onPressed: () {
                  // TODO: Navigate to full alerts screen
                },
                child: const Text('View all alerts'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(AlertModel alert, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: Colors.red[50],
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          child: const Icon(Icons.warning, color: Colors.white, size: 20),
        ),
        title: Text(
          alert.patientName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(alert.message),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM dd, yyyy HH:mm').format(alert.createdAt),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            final alertProvider = Provider.of<AlertProvider>(context, listen: false);
            await alertProvider.markAlertAsRead(alert.id);
          },
        ),
      ),
    );
  }

  Widget _buildStatisticsOverview(PatientProvider patientProvider, ColorScheme colorScheme) {
    final totalPatients = patientProvider.patients.length;
    final patientsWithEmotions = patientProvider.patientLatestEmotions.keys.length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Patients',
                    totalPatients.toString(),
                    Icons.people,
                    colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Active',
                    patientsWithEmotions.toString(),
                    Icons.favorite,
                    Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPatientsSection(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Patients',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Consumer<PatientProvider>(
          builder: (context, patientProvider, _) {
            if (patientProvider.isLoading) {
              return const LoadingWidget(message: 'Loading patients...');
            }

            if (patientProvider.patients.isEmpty) {
              return EmptyStateWidget(
                icon: Icons.people_outline,
                title: 'No patients found',
                message: 'Patients will appear here once they register',
              );
            }

            return Column(
              children: patientProvider.patients.map((patient) {
                return _buildPatientCard(patient, patientProvider, colorScheme);
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPatientCard(
    UserModel patient,
    PatientProvider patientProvider,
    ColorScheme colorScheme,
  ) {
    final latestEmotion = patientProvider.getLatestEmotionForPatient(patient.id);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to patient details
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      patient.fullName.isNotEmpty
                          ? patient.fullName[0].toUpperCase()
                          : 'P',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patient.fullName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          patient.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (latestEmotion != null)
                    _buildEmotionBadge(latestEmotion),
                ],
              ),
              if (latestEmotion != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getEmotionColor(latestEmotion.emotionType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getEmotionIcon(latestEmotion.emotionType),
                        color: _getEmotionColor(latestEmotion.emotionType),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Latest: ${latestEmotion.emotionType}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getEmotionColor(latestEmotion.emotionType),
                              ),
                            ),
                            Text(
                              DateFormat('MMM dd, yyyy HH:mm').format(latestEmotion.timestamp),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${(latestEmotion.confidence * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getEmotionColor(latestEmotion.emotionType),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.grey[600], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'No emotions recorded yet',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionBadge(EmotionModel emotion) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getEmotionColor(emotion.emotionType).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getEmotionIcon(emotion.emotionType),
            size: 16,
            color: _getEmotionColor(emotion.emotionType),
          ),
          const SizedBox(width: 4),
          Text(
            emotion.emotionType,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _getEmotionColor(emotion.emotionType),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEmotionIcon(String emotionType) {
    switch (emotionType) {
      case 'HAPPY':
        return Icons.sentiment_very_satisfied;
      case 'SAD':
        return Icons.sentiment_very_dissatisfied;
      case 'ANGRY':
        return Icons.sentiment_very_dissatisfied;
      case 'FEAR':
        return Icons.sentiment_dissatisfied;
      default:
        return Icons.sentiment_neutral;
    }
  }

  Color _getEmotionColor(String emotionType) {
    switch (emotionType) {
      case 'HAPPY':
        return Colors.green;
      case 'SAD':
        return Colors.blue;
      case 'ANGRY':
        return Colors.red;
      case 'FEAR':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

