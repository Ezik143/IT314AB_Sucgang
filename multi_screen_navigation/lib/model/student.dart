import '../core/formatting.dart';

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
  final bool isDeleted;

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
    this.isDeleted = false,
  });

  factory Student.fromRow(dynamic row) {
    return Student(
      studentId: row['student_id'],
      studentNumber: row['student_number'],
      firstName: row['first_name'],
      lastName: row['last_name'],
      email: row['email'],
      course: row['course'],
      yearLevel: row['year_level'],
      contactNumber: row['contact_number'] ?? '',
      createdAt: formatDate(row['created_at']),
      isDeleted: row['is_deleted'] == true,
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
