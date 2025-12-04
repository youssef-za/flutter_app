import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/emotion_model.dart';
import 'modern_card.dart';

class EmotionStatisticsWidget extends StatelessWidget {
  final List<EmotionModel> emotions;

  const EmotionStatisticsWidget({
    super.key,
    required this.emotions,
  });

  @override
  Widget build(BuildContext context) {
    if (emotions.isEmpty) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Calculate emotion frequency
    final emotionFrequency = <String, int>{};
    for (var emotion in emotions) {
      emotionFrequency[emotion.emotionType] =
          (emotionFrequency[emotion.emotionType] ?? 0) + 1;
    }

    // Find most frequent emotion
    final mostFrequent = emotionFrequency.entries.isNotEmpty
        ? emotionFrequency.entries
            .reduce((a, b) => a.value > b.value ? a : b)
        : null;

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
                  Icons.bar_chart_rounded,
                  color: colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Emotion Frequency',
                style: theme.textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (mostFrequent != null)
            _buildMostFrequentEmotion(mostFrequent.key, mostFrequent.value, theme, colorScheme),
          const SizedBox(height: 24),
          _buildFrequencyChart(emotionFrequency, theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildMostFrequentEmotion(String emotionType, int count, ThemeData theme, ColorScheme colorScheme) {
    final color = _getEmotionColor(emotionType);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(_getEmotionIcon(emotionType), color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Most Detected',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  emotionType,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$count times',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrequencyChart(Map<String, int> frequency, ThemeData theme, ColorScheme colorScheme) {
    final emotionTypes = ['HAPPY', 'SAD', 'ANGRY', 'FEAR', 'NEUTRAL'];
    final bars = <BarChartGroupData>[];

    for (int i = 0; i < emotionTypes.length; i++) {
      final type = emotionTypes[i];
      final count = frequency[type] ?? 0;
      bars.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: count.toDouble(),
              color: _getEmotionColor(type),
              width: 20,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < emotionTypes.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        emotionTypes[value.toInt()],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() == value) {
                    return Text(
                      value.toInt().toString(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: bars,
          maxY: frequency.values.isEmpty
              ? 1
              : frequency.values.reduce((a, b) => a > b ? a : b).toDouble() + 1,
        ),
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

