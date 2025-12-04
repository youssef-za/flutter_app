import 'package:flutter/material.dart';
import '../models/emotion_model.dart';

class EmotionCard extends StatelessWidget {
  final EmotionModel emotion;
  final VoidCallback? onTap;

  const EmotionCard({
    super.key,
    required this.emotion,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildEmotionIcon(emotion.emotionType),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      emotion.emotionType,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Confidence: ${(emotion.confidence * 100).toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(emotion.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getEmotionColor(emotion.emotionType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(emotion.confidence * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: _getEmotionColor(emotion.emotionType),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmotionIcon(String emotionType) {
    IconData icon;
    Color color;

    switch (emotionType) {
      case 'HAPPY':
        icon = Icons.sentiment_very_satisfied;
        color = Colors.green;
        break;
      case 'SAD':
        icon = Icons.sentiment_very_dissatisfied;
        color = Colors.blue;
        break;
      case 'ANGRY':
        icon = Icons.sentiment_very_dissatisfied;
        color = Colors.red;
        break;
      case 'FEAR':
        icon = Icons.sentiment_dissatisfied;
        color = Colors.orange;
        break;
      default:
        icon = Icons.sentiment_neutral;
        color = Colors.grey;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      radius: 24,
      child: Icon(icon, color: color, size: 28),
    );
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

