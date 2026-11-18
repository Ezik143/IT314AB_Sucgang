import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../model/subject.dart';

class SubjectRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<List<Subject>> getAllSubjects() async {
    final connection = await _dbService.connectDatabase();

    try {
      final result = await connection.execute('SELECT * FROM subject');

      List<Subject> subjects = [];

      for (var row in result) {
        final subject = Subject.fromRow(row.toColumnMap());
        subjects.add(subject);
      }

      return subjects;
    } finally {
      await connection.close();
    }
  }

  Future<Subject?> getSubjectById(int subjectId) async {
    final connection = await _dbService.connectDatabase();

    try {
      final result = await connection.execute(
        Sql.named('SELECT * FROM subject WHERE subject_id = @subject_id'),
        parameters: {'subject_id': subjectId},
      );

      if (result.isEmpty) {
        return null;
      }

      return Subject.fromRow(result.first.toColumnMap());
    } finally {
      await connection.close();
    }
  }

  Future<void> addSubject(Subject subject) async {
    final connection = await _dbService.connectDatabase();

    try {
      await connection.execute(
        Sql.named(
          'INSERT INTO subject (subject_code, subject_name, units, description, is_available) '
          'VALUES (@subject_code, @subject_name, @units, @description, @is_available)',
        ),
        parameters: subject.toParams(),
      );
    } finally {
      await connection.close();
    }
  }

  Future<void> updateSubject(Subject subject) async {
    if (subject.subjectId == null) {
      throw ArgumentError('Subject ID is required for updating.');
    }

    final connection = await _dbService.connectDatabase();

    try {
      await connection.execute(
        Sql.named(
          'UPDATE subject SET '
          'subject_code = @subject_code, '
          'subject_name = @subject_name, '
          'units = @units, '
          'description = @description, '
          'is_available = @is_available '
          'WHERE subject_id = @subject_id',
        ),
        parameters: {...subject.toParams(), 'subject_id': subject.subjectId},
      );
    } finally {
      await connection.close();
    }
  }

  Future<void> deleteSubject(int subjectId) async {
    final connection = await _dbService.connectDatabase();

    try {
      await connection.execute(
        Sql.named(
          'UPDATE subject SET is_available = FALSE '
          'WHERE subject_id = @subject_id',
        ),
        parameters: {'subject_id': subjectId},
      );
    } finally {
      await connection.close();
    }
  }
}
