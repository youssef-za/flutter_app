import 'package:flutter/material.dart';
import '../models/emotion_model.dart';
import 'modern_card.dart';

class StressIndicatorWidget extends StatelessWidget {
  final List<EmotionModel> emotions;

  const StressIndicatorWidget({
    super.key,
    required this.emotions,
  });

  @override
  Widget build(BuildContext context) {
    if (emotions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate stress level based on negative emotions (SAD, ANGRY, FEAR)
    final negativeEmotions = emotions.where((e) =>
        e.emotionType == 'SAD' ||
        e.emotionType == 'ANGRY' ||
        e.emotionType == 'FEAR').length;
    
    final stressLevel = (negativeEmotions / emotions.length * 100).round();
    
    Color stressColor;
    String stressLabel;
    IconData stressIcon;
    
    if (stressLevel < 25) {
      stressColor = Colors.green;
      stressLabel = 'Low';
      stressIcon = Icons.sentiment_very_satisfied;
    } else if (stressLevel < 50) {
      stressColor = Colors.orange;
      stressLabel = 'Moderate';
      stressIcon = Icons.sentiment_neutral;
    } else if (stressLevel < 75) {
      stressColor = Colors.deepOrange;
      stressLabel = 'High';
      stressIcon = Icons.sentiment_dissatisfied;
    } else {
      stressColor = Colors.red;
      stressLabel = 'Very High';
      stressIcon = Icons.sentiment_very_dissatisfied;
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ModernCard(
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
                  Icons.psychology_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Stress Level Indicator',
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stressLabel,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: stressColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$stressLevel% stress level',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: stressColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(stressIcon, size: 40, color: stressColor),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: stressLevel / 100,
              minHeight: 14,
              backgroundColor: colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(stressColor),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '0%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '100%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (stressLevel >= 50) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: stressColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: stressColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: stressColor, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Consider taking a break or speaking with your doctor',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: stressColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

