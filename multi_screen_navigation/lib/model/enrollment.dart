class Enrollment {
  final int? enrollmentId;
  final int studentId;
  final int subjectId;
  final int scheduleId;
  final String enrolledAt;
  final String status;
  final String? studentName;
  final String? subjectCode;
  final String? subjectName;
  final String? scheduleDescription;

  Enrollment({
    this.enrollmentId,
    required this.studentId,
    required this.subjectId,
    required this.scheduleId,
    required this.enrolledAt,
    required this.status,
    this.studentName,
    this.subjectCode,
    this.subjectName,
    this.scheduleDescription,
  });

  factory Enrollment.fromRow(dynamic row) {
    return Enrollment(
      enrollmentId: row['enrollment_id'],
      studentId: row['student_id'],
      subjectId: row['subject_id'],
      scheduleId: row['schedule_id'],
      enrolledAt: row['enrolled_at'].toString(),
      status: row['status'],
      studentName: row['student_name']?.toString(),
      subjectCode: row['subject_code']?.toString(),
      subjectName: row['subject_name']?.toString(),
      scheduleDescription: row['schedule_description']?.toString(),
    );
  }

  Map<String, dynamic> toParams() {
    return {
      'student_id': studentId,
      'subject_id': subjectId,
      'schedule_id': scheduleId,
      'enrolled_at': enrolledAt,
      'status': status,
    };
  }
}
