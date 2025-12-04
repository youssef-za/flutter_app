class PatientTagModel {
  final int id;
  final String tag;
  final int patientId;
  final String patientName;
  final int doctorId;
  final String doctorName;
  final DateTime createdAt;
  final DateTime updatedAt;

  PatientTagModel({
    required this.id,
    required this.tag,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientTagModel.fromJson(Map<String, dynamic> json) {
    return PatientTagModel(
      id: json['id'] as int,
      tag: json['tag'] as String,
      patientId: json['patientId'] as int,
      patientName: json['patientName'] as String,
      doctorId: json['doctorId'] as int,
      doctorName: json['doctorName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tag': tag,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

