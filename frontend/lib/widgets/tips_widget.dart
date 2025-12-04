import 'package:flutter/material.dart';
import 'dart:math';
import '../models/emotion_model.dart';
import 'modern_card.dart';

class TipsWidget extends StatelessWidget {
  final List<EmotionModel>? emotions;

  const TipsWidget({
    super.key,
    this.emotions,
  });

  static final List<String> _tips = [
    'Take deep breaths when feeling stressed. Inhale for 4 counts, hold for 4, exhale for 4.',
    'Regular exercise can help improve your mood and reduce stress levels.',
    'Getting 7-9 hours of sleep each night is essential for emotional well-being.',
    'Practice mindfulness meditation for 10 minutes daily to improve emotional awareness.',
    'Stay connected with friends and family - social support is important for mental health.',
    'Keep a gratitude journal. Write down 3 things you\'re grateful for each day.',
    'Limit screen time before bed to improve sleep quality.',
    'Spend time in nature - even 20 minutes can boost your mood.',
    'Listen to calming music when feeling anxious or stressed.',
    'Practice self-compassion - be kind to yourself, especially during difficult times.',
  ];

  @override
  Widget build(BuildContext context) {
    // Get a random tip or tip based on current emotion
    String tip = _getTipForToday();
    
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ModernCard(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.primaryContainer.withOpacity(0.5),
              colorScheme.secondaryContainer.withOpacity(0.3),
            ],
          ),
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.lightbulb_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Tip of the Day',
                  style: theme.textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.psychology_rounded,
                    color: colorScheme.onPrimaryContainer,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    tip,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTipForToday() {
    // Use day of year to get consistent tip for the day
    final dayOfYear = DateTime.now().difference(
      DateTime(DateTime.now().year, 1, 1),
    ).inDays;
    
    return _tips[dayOfYear % _tips.length];
  }
}

