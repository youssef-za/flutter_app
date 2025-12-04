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
import '../../../widgets/emotion_statistics_widget.dart';
import '../../../widgets/weekly_statistics_widget.dart';
import '../../../widgets/stress_indicator_widget.dart';
import '../../../widgets/tips_widget.dart';
import '../../../widgets/modern_card.dart';
import '../../../widgets/animated_fade_in.dart';
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

            // Emotion Statistics
            Consumer<EmotionProvider>(
              builder: (context, emotionProvider, _) {
                if (emotionProvider.emotions.isNotEmpty) {
                  return AnimatedFadeIn(
                    child: Column(
                      children: [
                        EmotionStatisticsWidget(emotions: emotionProvider.emotions),
                        const SizedBox(height: 20),
                        WeeklyStatisticsWidget(emotions: emotionProvider.emotions),
                        const SizedBox(height: 20),
                        StressIndicatorWidget(emotions: emotionProvider.emotions),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20),
            
            // Tips of the Day
            Consumer<EmotionProvider>(
              builder: (context, emotionProvider, _) {
                return AnimatedFadeIn(
                  child: TipsWidget(emotions: emotionProvider.emotions),
                );
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
    final theme = Theme.of(context);

    return ModernCard(
      padding: const EdgeInsets.all(28.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              emotionColor.withOpacity(0.15),
              emotionColor.withOpacity(0.05),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Emotion Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: emotionColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                emotionIcon,
                size: 72,
                color: emotionColor,
              ),
            ),
            const SizedBox(height: 24),

            // Emotion Type
            Text(
              emotion.emotionType,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: emotionColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Confidence
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: emotionColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                '${(emotion.confidence * 100).toStringAsFixed(1)}% Confidence',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: emotionColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy • HH:mm').format(emotion.timestamp),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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
    final theme = Theme.of(context);
    return ModernCard(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sentiment_neutral_rounded,
              size: 64,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No emotion detected yet',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Capture your first emotion to get started',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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
            );
          },
        ),
        const SizedBox(height: 12),

        // View History Button
        CustomButton(
          text: 'View Emotion History',
          onPressed: _navigateToHistory,
          icon: Icons.history_rounded,
          isFilled: false,
        ),
      ],
    );
  }

  Widget _buildQuickStats(List<EmotionModel> emotions, ColorScheme colorScheme) {
    final totalEmotions = emotions.length;
    final happyCount = emotions.where((e) => e.emotionType == 'HAPPY').length;
    final sadCount = emotions.where((e) => e.emotionType == 'SAD').length;
    final theme = Theme.of(context);

    return ModernCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total',
                  totalEmotions.toString(),
                  Icons.emoji_emotions_rounded,
                  colorScheme.primary,
                  theme,
                  colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Happy',
                  happyCount.toString(),
                  Icons.sentiment_very_satisfied_rounded,
                  Colors.green,
                  theme,
                  colorScheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Sad',
                  sadCount.toString(),
                  Icons.sentiment_very_dissatisfied_rounded,
                  Colors.blue,
                  theme,
                  colorScheme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color, ThemeData theme, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
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


