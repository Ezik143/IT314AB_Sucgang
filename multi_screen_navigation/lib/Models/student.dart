class Student {
  final int? studentId;
  final String studentNumber;
  final String firstName;
  final String lastName;
  final String email;
  final String course;
  final int yearLevel;
  final String contactNumber;
  final String createdAt;

  Student({
    this.studentId,
    required this.studentNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.course,
    required this.yearLevel,
    required this.contactNumber,
    required this.createdAt,
  });

  factory Student.fromRow(dynamic row) {
    return Student(
      studentId: row['student_id'] == null
          ? null
          : int.tryParse(row['student_id'].toString()),
      studentNumber: row['student_number']?.toString() ?? '',
      firstName: row['first_name']?.toString() ?? '',
      lastName: row['last_name']?.toString() ?? '',
      email: row['email']?.toString() ?? '',
      course: row['course']?.toString() ?? '',
      yearLevel: int.tryParse(row['year_level']?.toString() ?? '0') ?? 0,
      contactNumber: row['contact_number']?.toString() ?? '',
      createdAt: row['created_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toParams() {
    return {
      'student_number': studentNumber,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'course': course,
      'year_level': yearLevel,
      'contact_number': contactNumber,
    };
  }
}
