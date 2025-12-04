import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../providers/emotion_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../models/emotion_model.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../screens/camera/camera_screen.dart';
import '../../../services/navigation_service.dart';
import '../../../config/app_routes.dart';
import 'history_tab.dart';

class PatientDashboardTab extends StatefulWidget {
  const PatientDashboardTab({super.key});

  @override
  State<PatientDashboardTab> createState() => _PatientDashboardTabState();
}

class _PatientDashboardTabState extends State<PatientDashboardTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCurrentEmotion();
    });
  }

  Future<void> _loadCurrentEmotion() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.currentUser != null) {
      final emotionProvider =
          Provider.of<EmotionProvider>(context, listen: false);
      await emotionProvider.loadEmotionHistory(authProvider.currentUser!.id);
    }
  }

  Future<void> _captureEmotionFromCamera() async {
    // Navigate to dedicated camera screen
    final result = await NavigationService.toEmotionCapture();

    // Reload emotions if capture was successful
    if (result == true && mounted) {
      await _loadCurrentEmotion();
    }
  }

  void _navigateToHistory() {
    // Navigate to history tab - this is handled by HomeScreen's tab navigation
    // The history tab is accessible via the bottom navigation bar
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: _loadCurrentEmotion,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Section
            _buildWelcomeSection(colorScheme),
            const SizedBox(height: 24),

            // Current Emotion Card
            Consumer<EmotionProvider>(
              builder: (context, emotionProvider, _) {
                if (emotionProvider.isLoading && emotionProvider.lastEmotion == null) {
                  return const LoadingWidget(message: 'Loading your emotion...');
                }

                if (emotionProvider.lastEmotion == null) {
                  return _buildNoEmotionCard(colorScheme);
                }

                return _buildCurrentEmotionCard(
                  emotionProvider.lastEmotion!,
                  colorScheme,
                );
              },
            ),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(colorScheme),
            const SizedBox(height: 24),

            // Quick Stats (optional)
            Consumer<EmotionProvider>(
              builder: (context, emotionProvider, _) {
                if (emotionProvider.emotions.isNotEmpty) {
                  return _buildQuickStats(emotionProvider.emotions, colorScheme);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(ColorScheme colorScheme) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final userName = authProvider.currentUser?.fullName ?? 'Patient';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              userName.split(' ').first,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrentEmotionCard(EmotionModel emotion, ColorScheme colorScheme) {
    final emotionColor = _getEmotionColor(emotion.emotionType);
    final emotionIcon = _getEmotionIcon(emotion.emotionType);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              emotionColor.withOpacity(0.1),
              emotionColor.withOpacity(0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Emotion Icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: emotionColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                emotionIcon,
                size: 64,
                color: emotionColor,
              ),
            ),
            const SizedBox(height: 20),

            // Emotion Type
            Text(
              emotion.emotionType,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: emotionColor,
              ),
            ),
            const SizedBox(height: 12),

            // Confidence
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: emotionColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${(emotion.confidence * 100).toStringAsFixed(1)}% Confidence',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: emotionColor,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 6),
                Text(
                  DateFormat('MMM dd, yyyy • HH:mm').format(emotion.timestamp),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoEmotionCard(ColorScheme colorScheme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.sentiment_neutral,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No emotion detected yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Capture your first emotion to get started',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Capture Emotion Button
        Consumer<EmotionProvider>(
          builder: (context, emotionProvider, _) {
            return CustomButton(
              text: 'Capture New Emotion',
              onPressed: emotionProvider.isLoading ? null : _captureEmotionFromCamera,
              isLoading: emotionProvider.isLoading,
              icon: Icons.camera_alt_rounded,
              backgroundColor: colorScheme.primary,
            );
          },
        ),
        const SizedBox(height: 12),

        // View History Button
        OutlinedButton.icon(
          onPressed: _navigateToHistory,
          icon: const Icon(Icons.history_rounded),
          label: const Text('View Emotion History'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: colorScheme.primary, width: 2),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(List<EmotionModel> emotions, ColorScheme colorScheme) {
    final totalEmotions = emotions.length;
    final happyCount = emotions.where((e) => e.emotionType == 'HAPPY').length;
    final sadCount = emotions.where((e) => e.emotionType == 'SAD').length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total',
                    totalEmotions.toString(),
                    Icons.emoji_emotions,
                    colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    'Happy',
                    happyCount.toString(),
                    Icons.sentiment_very_satisfied,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatItem(
                    'Sad',
                    sadCount.toString(),
                    Icons.sentiment_very_dissatisfied,
                    Colors.blue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
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


