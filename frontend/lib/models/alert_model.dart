class AlertModel {
  final int id;
  final String message;
  final DateTime createdAt;
  final bool isRead;
  final int patientId;
  final String patientName;
  final int doctorId;
  final String doctorName;

  AlertModel({
    required this.id,
    required this.message,
    required this.createdAt,
    required this.isRead,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] as int,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool,
      patientId: json['patientId'] as int,
      patientName: json['patientName'] as String,
      doctorId: json['doctorId'] as int,
      doctorName: json['doctorName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
    };
  }
}

