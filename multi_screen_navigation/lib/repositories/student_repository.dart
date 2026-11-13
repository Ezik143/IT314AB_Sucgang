import 'package:multi_screen_navigation/core/db_connection.dart';
import 'package:multi_screen_navigation/Models/student.dart';

class StudentRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<List<Student>> getAllStudents() async {
    try {
      final connection = await _dbService.getConnection();

      final result = await connection.execute(
        'SELECT student_id, student_number, first_name, last_name, '
        'email, course, year_level, contact_number, created_at '
        'FROM student '
        'ORDER BY last_name, first_name',
      );

      return result.map((row) => Student.fromRow(row)).toList();
    } catch (e) {
      print('Error fetching students: $e');
      throw Exception('Failed to load students from database.');
    }
  }
}
