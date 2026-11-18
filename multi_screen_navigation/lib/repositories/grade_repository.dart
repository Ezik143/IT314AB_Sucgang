import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../model/grade.dart';

class GradeRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<List<Grade>> getAllGrades() async {
    final connection = await _dbService.connectDatabase();
    try {
      final result = await connection.execute(
        'SELECT g.*, s.first_name || \' \' || s.last_name AS student_name, '
        'sub.subject_code, sub.subject_name '
        'FROM grades g '
        'LEFT JOIN enrollment e ON e.enrollment_id = g.enrollment_id '
        'LEFT JOIN student s ON s.student_id = e.student_id '
        'LEFT JOIN subject sub ON sub.subject_id = e.subject_id '
        'ORDER BY g.date_recorded DESC, g.grade_id DESC',
      );
      return result.map((row) => Grade.fromRow(row.toColumnMap())).toList();
    } finally {}
  }

  Future<void> addGrade(Grade grade) async {
    final connection = await _dbService.connectDatabase();
    try {
      await _validateEnrollment(connection, grade.enrollmentId);
      await connection.execute(
        Sql.named(
          'INSERT INTO grades '
          '(enrollment_id, grade_value, remarks, date_recorded) '
          'VALUES (@enrollment_id, @grade_value, @remarks, @date_recorded)',
        ),
        parameters: grade.toParams(),
      );
    } finally {}
  }

  Future<void> updateGrade(Grade grade) async {
    if (grade.gradeId == null) {
      throw ArgumentError('Grade ID is required for updating.');
    }

    final connection = await _dbService.connectDatabase();
    try {
      await _validateEnrollment(connection, grade.enrollmentId);
      await connection.execute(
        Sql.named(
          'UPDATE grades SET '
          'enrollment_id = @enrollment_id, '
          'grade_value = @grade_value, '
          'remarks = @remarks, '
          'date_recorded = @date_recorded '
          'WHERE grade_id = @grade_id',
        ),
        parameters: {...grade.toParams(), 'grade_id': grade.gradeId},
      );
    } finally {}
  }

  Future<void> deleteGrade(int gradeId) async {
    final connection = await _dbService.connectDatabase();
    try {
      await connection.execute(
        Sql.named('DELETE FROM grades WHERE grade_id = @grade_id'),
        parameters: {'grade_id': gradeId},
      );
    } finally {}
  }

  Future<List<Grade>> getGradesByStudent(int studentId) async {
    final connection = await _dbService.connectDatabase();
    try {
      final result = await connection.execute(
        Sql.named(
          'SELECT g.*, sub.subject_code, sub.subject_name '
          'FROM grades g '
          'LEFT JOIN enrollment e ON e.enrollment_id = g.enrollment_id '
          'LEFT JOIN subject sub ON sub.subject_id = e.subject_id '
          'WHERE e.student_id = @student_id '
          'ORDER BY g.date_recorded DESC, g.grade_id DESC',
        ),
        parameters: {'student_id': studentId},
      );
      return result.map((row) => Grade.fromRow(row.toColumnMap())).toList();
    } finally {}
  }

  Future<void> _validateEnrollment(
    Connection connection,
    int enrollmentId,
  ) async {
    final result = await connection.execute(
      Sql.named(
        'SELECT enrollment_id FROM enrollment '
        'WHERE enrollment_id = @enrollment_id '
        'AND status = @status',
      ),
      parameters: {'enrollment_id': enrollmentId, 'status': 'Enrolled'},
    );
    if (result.isEmpty) {
      throw ArgumentError(
        'Grade must be associated with an existing enrolled record.',
      );
    }
  }
}
