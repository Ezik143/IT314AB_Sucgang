class Grade {
  final int? gradeId;
  final int enrollmentId;
  final double gradeValue;
  final String remarks;
  final String dateRecorded;
  final String? studentName;
  final String? subjectCode;
  final String? subjectName;

  Grade({
    this.gradeId,
    required this.enrollmentId,
    required this.gradeValue,
    required this.remarks,
    required this.dateRecorded,
    this.studentName,
    this.subjectCode,
    this.subjectName,
  });

  factory Grade.fromRow(dynamic row) {
    return Grade(
      gradeId: row['grade_id'],
      enrollmentId: row['enrollment_id'],
      gradeValue: double.parse(row['grade_value'].toString()),
      remarks: row['remarks'],
      dateRecorded: row['date_recorded'].toString(),
      studentName: row['student_name']?.toString(),
      subjectCode: row['subject_code']?.toString(),
      subjectName: row['subject_name']?.toString(),
    );
  }

  Map<String, dynamic> toParams() {
    return {
      'enrollment_id': enrollmentId,
      'grade_value': gradeValue,
      'remarks': remarks,
      'date_recorded': dateRecorded,
    };
  }
}
