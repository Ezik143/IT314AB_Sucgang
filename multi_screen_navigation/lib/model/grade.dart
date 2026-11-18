class Grade {
  final int? gradeId;
  final int enrollmentId;
  final double gradeValue;
  final String remarks;
  final String dateRecorded;

  Grade({
    this.gradeId,
    required this.enrollmentId,
    required this.gradeValue,
    required this.remarks,
    required this.dateRecorded,
  });

  factory Grade.fromRow(dynamic row) {
    return Grade(
      gradeId: row['grade_id'],
      enrollmentId: row['enrollment_id'],
      gradeValue: (row['grade_value'] as num).toDouble(),
      remarks: row['remarks'],
      dateRecorded: row['date_recorded'].toString(),
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
