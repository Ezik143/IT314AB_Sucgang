class Subject {
  final int? subjectId;
  final String subjectCode;
  final String subjectName;
  final int units;
  final String description;
  final bool isAvailable;

  Subject({
    this.subjectId,
    required this.subjectCode,
    required this.subjectName,
    required this.units,
    required this.description,
    this.isAvailable = true,
  });

  factory Subject.fromRow(dynamic row) {
    return Subject(
      subjectId: row['subject_id'],
      subjectCode: row['subject_code'],
      subjectName: row['subject_name'],
      units: row['units'],
      description: row['description'],
      isAvailable: row['is_available'],
    );
  }

  Map<String, dynamic> toParams() {
    return {
      'subject_id': subjectId,
      'subject_code': subjectCode,
      'subject_name': subjectName,
      'units': units,
      'description': description,
      'is_available': isAvailable,
    };
  }
}
