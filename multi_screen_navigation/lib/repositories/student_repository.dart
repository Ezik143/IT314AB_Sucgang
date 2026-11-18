import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../model/student.dart';

class StudentRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<List<Student>> getAllStudents() async {
    final connection = await _dbService.connectDatabase();

    try {
      final result = await connection.execute(
        'SELECT * FROM student '
        'WHERE is_deleted = FALSE '
        'ORDER BY last_name, first_name',
      );

      return result.map((row) => Student.fromRow(row.toColumnMap())).toList();
    } finally {}
  }

  Future<Student?> getStudentById(int studentId) async {
    final connection = await _dbService.connectDatabase();

    try {
      final result = await connection.execute(
        Sql.named('SELECT * FROM student WHERE student_id = @student_id'),
        parameters: {'student_id': studentId},
      );

      if (result.isEmpty) {
        return null;
      }

      return Student.fromRow(result.first.toColumnMap());
    } finally {}
  }

  Future<void> addStudent(Student student) async {
    final connection = await _dbService.connectDatabase();

    try {
      await connection.execute(
        Sql.named(
          'INSERT INTO student '
          '(student_number, first_name, last_name, email, course, '
          'year_level, contact_number) '
          'VALUES (@student_number, @first_name, @last_name, @email, '
          '@course, @year_level, @contact_number)',
        ),
        parameters: student.toParams(),
      );
    } finally {}
  }

  Future<void> updateStudent(Student student) async {
    if (student.studentId == null) {
      throw ArgumentError('Student ID is required for updating.');
    }

    final connection = await _dbService.connectDatabase();

    try {
      await connection.execute(
        Sql.named(
          'UPDATE student SET '
          'student_number = @student_number, '
          'first_name = @first_name, '
          'last_name = @last_name, '
          'email = @email, '
          'course = @course, '
          'year_level = @year_level, '
          'contact_number = @contact_number '
          'WHERE student_id = @student_id',
        ),
        parameters: {...student.toParams(), 'student_id': student.studentId},
      );
    } finally {}
  }

  Future<void> deleteStudent(int studentId) async {
    final connection = await _dbService.connectDatabase();

    try {
      await connection.execute(
        Sql.named(
          'UPDATE student '
          'SET is_deleted = TRUE '
          'WHERE student_id = @student_id',
        ),
        parameters: {'student_id': studentId},
      );
    } finally {}
  }
}
