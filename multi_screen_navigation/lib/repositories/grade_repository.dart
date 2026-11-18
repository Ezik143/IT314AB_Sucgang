import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../model/grade.dart';

class GradeRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<List<Grade>> getAllGrades() async {
    final connection = await _dbService.connectDatabase();
    try {
      final result = await connection.execute(
        'SELECT * FROM grade ORDER BY date_recorded DESC, grade_id DESC',
      );
      return result.map((row) => Grade.fromRow(row.toColumnMap())).toList();
    } finally {
      await connection.close();
    }
  }

  Future<void> addGrade(Grade grade) async {
    final connection = await _dbService.connectDatabase();
    try {
      await connection.execute(
        Sql.named(
          'INSERT INTO grade '
          '(enrollment_id, grade_value, remarks, date_recorded) '
          'VALUES (@enrollment_id, @grade_value, @remarks, @date_recorded)',
        ),
        parameters: grade.toParams(),
      );
    } finally {
      await connection.close();
    }
  }

  Future<void> updateGrade(Grade grade) async {
    if (grade.gradeId == null) {
      throw ArgumentError('Grade ID is required for updating.');
    }

    final connection = await _dbService.connectDatabase();
    try {
      await connection.execute(
        Sql.named(
          'UPDATE grade SET '
          'enrollment_id = @enrollment_id, '
          'grade_value = @grade_value, '
          'remarks = @remarks, '
          'date_recorded = @date_recorded '
          'WHERE grade_id = @grade_id',
        ),
        parameters: {...grade.toParams(), 'grade_id': grade.gradeId},
      );
    } finally {
      await connection.close();
    }
  }

  Future<void> deleteGrade(int gradeId) async {
    final connection = await _dbService.connectDatabase();
    try {
      await connection.execute(
        Sql.named('DELETE FROM grade WHERE grade_id = @grade_id'),
        parameters: {'grade_id': gradeId},
      );
    } finally {
      await connection.close();
    }
  }
}
