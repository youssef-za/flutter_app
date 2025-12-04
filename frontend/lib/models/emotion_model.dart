class EmotionModel {
  final int? id;
  final String emotionType;
  final double confidence;
  final DateTime timestamp;
  final int? patientId;
  final String? patientName;

  EmotionModel({
    this.id,
    required this.emotionType,
    required this.confidence,
    required this.timestamp,
    this.patientId,
    this.patientName,
  });

  factory EmotionModel.fromJson(Map<String, dynamic> json) {
    return EmotionModel(
      id: json['id'] as int?,
      emotionType: json['emotionType'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
      patientId: json['patientId'] as int?,
      patientName: json['patientName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emotionType': emotionType,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'patientId': patientId,
      'patientName': patientName,
    };
  }
}

