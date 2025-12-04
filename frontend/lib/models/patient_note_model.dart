class PatientNoteModel {
  final int id;
  final String note;
  final int patientId;
  final String patientName;
  final int doctorId;
  final String doctorName;
  final DateTime createdAt;
  final DateTime updatedAt;

  PatientNoteModel({
    required this.id,
    required this.note,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PatientNoteModel.fromJson(Map<String, dynamic> json) {
    return PatientNoteModel(
      id: json['id'] as int,
      note: json['note'] as String,
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
      'note': note,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

