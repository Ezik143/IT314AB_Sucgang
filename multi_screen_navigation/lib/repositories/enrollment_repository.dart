import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../model/enrollment.dart';

class EnrollmentRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<List<Enrollment>> getAllEnrollments() async {
    final connection = await _dbService.connectDatabase();
    try {
      final result = await connection.execute(
        'SELECT e.*, '
        's.first_name || \' \' || s.last_name AS student_name, '
        'sub.subject_code, sub.subject_name, '
        'sch.day_of_week || \' \' || sch.start_time::text || \' - \' || '
        'sch.end_time::text || \' in \' || sch.room AS schedule_description '
        'FROM enrollment e '
        'LEFT JOIN student s ON s.student_id = e.student_id '
        'LEFT JOIN subject sub ON sub.subject_id = e.subject_id '
        'LEFT JOIN schedule sch ON sch.schedule_id = e.schedule_id '
        'ORDER BY e.enrolled_at DESC, e.enrollment_id DESC',
      );
      return result
          .map((row) => Enrollment.fromRow(row.toColumnMap()))
          .toList();
    } finally {}
  }

  Future<Enrollment?> getEnrollmentById(int enrollmentId) async {
    final connection = await _dbService.connectDatabase();
    try {
      final result = await connection.execute(
        Sql.named(
          'SELECT * FROM enrollment WHERE enrollment_id = @enrollment_id',
        ),
        parameters: {'enrollment_id': enrollmentId},
      );
      if (result.isEmpty) return null;
      return Enrollment.fromRow(result.first.toColumnMap());
    } finally {}
  }

  Future<void> addEnrollment(Enrollment enrollment) async {
    final connection = await _dbService.connectDatabase();
    try {
      await _validateEnrollment(
        connection,
        studentId: enrollment.studentId,
        subjectId: enrollment.subjectId,
        scheduleId: enrollment.scheduleId,
      );
      await connection.execute(
        Sql.named(
          'INSERT INTO enrollment '
          '(student_id, subject_id, schedule_id, enrolled_at, status) '
          'VALUES (@student_id, @subject_id, @schedule_id, '
          '@enrolled_at, @status)',
        ),
        parameters: enrollment.toParams(),
      );
    } finally {}
  }

  Future<void> updateEnrollment(Enrollment enrollment) async {
    if (enrollment.enrollmentId == null) {
      throw ArgumentError('Enrollment ID is required for updating.');
    }
    final connection = await _dbService.connectDatabase();
    try {
      await _validateEnrollment(
        connection,
        studentId: enrollment.studentId,
        subjectId: enrollment.subjectId,
        scheduleId: enrollment.scheduleId,
        excludeEnrollmentId: enrollment.enrollmentId,
      );
      await connection.execute(
        Sql.named(
          'UPDATE enrollment SET '
          'student_id = @student_id, '
          'subject_id = @subject_id, '
          'schedule_id = @schedule_id, '
          'enrolled_at = @enrolled_at, '
          'status = @status '
          'WHERE enrollment_id = @enrollment_id',
        ),
        parameters: {
          ...enrollment.toParams(),
          'enrollment_id': enrollment.enrollmentId,
        },
      );
    } finally {}
  }

  Future<void> deleteEnrollment(int enrollmentId) async {
    final connection = await _dbService.connectDatabase();
    try {
      await connection.execute(
        Sql.named(
          'UPDATE enrollment SET status = @status '
          'WHERE enrollment_id = @enrollment_id',
        ),
        parameters: {'enrollment_id': enrollmentId, 'status': 'Dropped'},
      );
    } finally {}
  }

  Future<List<Enrollment>> getEnrollmentsByStudent(int studentId) async {
    final connection = await _dbService.connectDatabase();
    try {
      final result = await connection.execute(
        Sql.named(
          'SELECT e.*, sub.subject_code, sub.subject_name, '
          'sch.day_of_week || \' \' || sch.start_time::text || \' - \' || '
          'sch.end_time::text || \' in \' || sch.room AS schedule_description '
          'FROM enrollment e '
          'LEFT JOIN subject sub ON sub.subject_id = e.subject_id '
          'LEFT JOIN schedule sch ON sch.schedule_id = e.schedule_id '
          'WHERE e.student_id = @student_id '
          'ORDER BY e.enrolled_at DESC, e.enrollment_id DESC',
        ),
        parameters: {'student_id': studentId},
      );
      return result
          .map((row) => Enrollment.fromRow(row.toColumnMap()))
          .toList();
    } finally {}
  }

  Future<void> _validateEnrollment(
    Connection connection, {
    required int studentId,
    required int subjectId,
    required int scheduleId,
    int? excludeEnrollmentId,
  }) async {
    final student = await connection.execute(
      Sql.named(
        'SELECT student_id FROM student '
        'WHERE student_id = @student_id AND is_deleted = FALSE',
      ),
      parameters: {'student_id': studentId},
    );
    if (student.isEmpty) {
      throw ArgumentError('Selected student does not exist.');
    }

    final subject = await connection.execute(
      Sql.named(
        'SELECT subject_id FROM subject '
        'WHERE subject_id = @subject_id AND is_available = TRUE',
      ),
      parameters: {'subject_id': subjectId},
    );
    if (subject.isEmpty) {
      throw ArgumentError('Selected subject is not available.');
    }

    final schedule = await connection.execute(
      Sql.named(
        'SELECT schedule_id FROM schedule '
        'WHERE schedule_id = @schedule_id AND subject_id = @subject_id',
      ),
      parameters: {'schedule_id': scheduleId, 'subject_id': subjectId},
    );
    if (schedule.isEmpty) {
      throw ArgumentError('Selected schedule does not belong to the subject.');
    }

    final duplicateSql = excludeEnrollmentId == null
        ? 'SELECT enrollment_id FROM enrollment '
              'WHERE student_id = @student_id '
              'AND subject_id = @subject_id AND status = @status'
        : 'SELECT enrollment_id FROM enrollment '
              'WHERE student_id = @student_id '
              'AND subject_id = @subject_id AND status = @status '
              'AND enrollment_id != @exclude_enrollment_id';
    final parameters = <String, dynamic>{
      'student_id': studentId,
      'subject_id': subjectId,
      'status': 'Enrolled',
    };
    if (excludeEnrollmentId != null) {
      parameters['exclude_enrollment_id'] = excludeEnrollmentId;
    }
    final duplicate = await connection.execute(
      Sql.named(duplicateSql),
      parameters: parameters,
    );
    if (duplicate.isNotEmpty) {
      throw ArgumentError('Student is already enrolled in this subject.');
    }

    final selectedSchedule = await connection.execute(
      Sql.named(
        'SELECT day_of_week, start_time, end_time, slot_capacity '
        'FROM schedule WHERE schedule_id = @schedule_id',
      ),
      parameters: {'schedule_id': scheduleId},
    );
    final selected = selectedSchedule.first.toColumnMap();
    final selectedCapacity = (selected['slot_capacity'] as num).toInt();
    final selectedDay = selected['day_of_week'].toString();
    final selectedStart = selected['start_time'].toString();
    final selectedEnd = selected['end_time'].toString();

    final capacity = await connection.execute(
      Sql.named(
        excludeEnrollmentId == null
            ? 'SELECT COUNT(*) AS enrolled_count FROM enrollment '
                  'WHERE schedule_id = @schedule_id AND status = @status'
            : 'SELECT COUNT(*) AS enrolled_count FROM enrollment '
                  'WHERE schedule_id = @schedule_id AND status = @status '
                  'AND enrollment_id != @exclude_enrollment_id',
      ),
      parameters: excludeEnrollmentId == null
          ? {'schedule_id': scheduleId, 'status': 'Enrolled'}
          : {
              'schedule_id': scheduleId,
              'status': 'Enrolled',
              'exclude_enrollment_id': excludeEnrollmentId,
            },
    );
    final enrolledCount =
        (capacity.first.toColumnMap()['enrolled_count'] as num).toInt();
    if (enrolledCount >= selectedCapacity) {
      throw ArgumentError('This schedule has no remaining slots.');
    }

    final conflictResult = await connection.execute(
      Sql.named(
        excludeEnrollmentId == null
            ? 'SELECT s.day_of_week, s.start_time, s.end_time '
                  'FROM enrollment e '
                  'JOIN schedule s ON s.schedule_id = e.schedule_id '
                  'WHERE e.student_id = @student_id '
                  'AND e.status = @status '
                  'AND s.day_of_week = @day_of_week'
            : 'SELECT s.day_of_week, s.start_time, s.end_time '
                  'FROM enrollment e '
                  'JOIN schedule s ON s.schedule_id = e.schedule_id '
                  'WHERE e.student_id = @student_id '
                  'AND e.status = @status '
                  'AND s.day_of_week = @day_of_week '
                  'AND e.enrollment_id != @exclude_enrollment_id',
      ),
      parameters: excludeEnrollmentId == null
          ? {
              'student_id': studentId,
              'status': 'Enrolled',
              'day_of_week': selectedDay,
            }
          : {
              'student_id': studentId,
              'status': 'Enrolled',
              'day_of_week': selectedDay,
              'exclude_enrollment_id': excludeEnrollmentId,
            },
    );
    for (final row in conflictResult) {
      final scheduled = row.toColumnMap();
      final start = scheduled['start_time'].toString();
      final end = scheduled['end_time'].toString();
      final overlaps =
          selectedStart.compareTo(end) < 0 && start.compareTo(selectedEnd) < 0;
      if (overlaps) {
        throw ArgumentError('This schedule conflicts with another enrollment.');
      }
    }
  }

  Future<void> seedEnrollments() async {
    const records = <Map<String, Object>>[
      {
        'enrollment_id': 1,
        'student_id': 1,
        'subject_id': 1,
        'schedule_id': 1,
        'enrolled_at': '2026-11-10 08:00:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 2,
        'student_id': 1,
        'subject_id': 3,
        'schedule_id': 4,
        'enrolled_at': '2026-11-10 08:10:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 3,
        'student_id': 1,
        'subject_id': 7,
        'schedule_id': 8,
        'enrolled_at': '2026-11-10 08:20:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 4,
        'student_id': 2,
        'subject_id': 1,
        'schedule_id': 2,
        'enrolled_at': '2026-11-10 09:00:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 5,
        'student_id': 2,
        'subject_id': 4,
        'schedule_id': 5,
        'enrolled_at': '2026-11-10 09:10:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 6,
        'student_id': 2,
        'subject_id': 8,
        'schedule_id': 9,
        'enrolled_at': '2026-11-10 09:20:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 7,
        'student_id': 3,
        'subject_id': 2,
        'schedule_id': 3,
        'enrolled_at': '2026-11-10 10:00:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 8,
        'student_id': 3,
        'subject_id': 5,
        'schedule_id': 6,
        'enrolled_at': '2026-11-10 10:10:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 9,
        'student_id': 3,
        'subject_id': 7,
        'schedule_id': 8,
        'enrolled_at': '2026-11-10 10:20:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 10,
        'student_id': 4,
        'subject_id': 2,
        'schedule_id': 10,
        'enrolled_at': '2026-11-11 08:00:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 11,
        'student_id': 4,
        'subject_id': 6,
        'schedule_id': 7,
        'enrolled_at': '2026-11-11 08:10:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 12,
        'student_id': 4,
        'subject_id': 8,
        'schedule_id': 9,
        'enrolled_at': '2026-11-11 08:20:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 13,
        'student_id': 5,
        'subject_id': 1,
        'schedule_id': 1,
        'enrolled_at': '2026-11-11 09:00:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 14,
        'student_id': 5,
        'subject_id': 4,
        'schedule_id': 5,
        'enrolled_at': '2026-11-11 09:10:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 15,
        'student_id': 5,
        'subject_id': 6,
        'schedule_id': 7,
        'enrolled_at': '2026-11-11 09:20:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 16,
        'student_id': 6,
        'subject_id': 1,
        'schedule_id': 2,
        'enrolled_at': '2026-11-11 10:00:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 17,
        'student_id': 6,
        'subject_id': 3,
        'schedule_id': 4,
        'enrolled_at': '2026-11-11 10:10:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 18,
        'student_id': 6,
        'subject_id': 5,
        'schedule_id': 6,
        'enrolled_at': '2026-11-11 10:20:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 19,
        'student_id': 7,
        'subject_id': 2,
        'schedule_id': 3,
        'enrolled_at': '2026-11-12 08:00:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 20,
        'student_id': 7,
        'subject_id': 4,
        'schedule_id': 5,
        'enrolled_at': '2026-11-12 08:10:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 21,
        'student_id': 7,
        'subject_id': 7,
        'schedule_id': 8,
        'enrolled_at': '2026-11-12 08:20:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 22,
        'student_id': 8,
        'subject_id': 2,
        'schedule_id': 10,
        'enrolled_at': '2026-11-12 09:00:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 23,
        'student_id': 8,
        'subject_id': 3,
        'schedule_id': 4,
        'enrolled_at': '2026-11-12 09:10:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 24,
        'student_id': 8,
        'subject_id': 8,
        'schedule_id': 9,
        'enrolled_at': '2026-11-12 09:20:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 25,
        'student_id': 9,
        'subject_id': 1,
        'schedule_id': 1,
        'enrolled_at': '2026-11-12 10:00:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 26,
        'student_id': 9,
        'subject_id': 5,
        'schedule_id': 6,
        'enrolled_at': '2026-11-12 10:10:00',
        'status': 'Dropped',
      },
      {
        'enrollment_id': 27,
        'student_id': 9,
        'subject_id': 7,
        'schedule_id': 8,
        'enrolled_at': '2026-11-12 10:20:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 28,
        'student_id': 10,
        'subject_id': 1,
        'schedule_id': 2,
        'enrolled_at': '2026-11-12 11:00:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 29,
        'student_id': 10,
        'subject_id': 6,
        'schedule_id': 7,
        'enrolled_at': '2026-11-12 11:10:00',
        'status': 'Enrolled',
      },
      {
        'enrollment_id': 30,
        'student_id': 10,
        'subject_id': 8,
        'schedule_id': 9,
        'enrolled_at': '2026-11-12 11:20:00',
        'status': 'Enrolled',
      },
    ];

    final connection = await _dbService.connectDatabase();
    try {
      for (final record in records) {
        final existing = await connection.execute(
          Sql.named(
            'SELECT enrollment_id FROM enrollment '
            'WHERE enrollment_id = @enrollment_id',
          ),
          parameters: {'enrollment_id': record['enrollment_id']},
        );
        if (existing.isNotEmpty) continue;

        await connection.execute(
          Sql.named(
            'INSERT INTO enrollment '
            '(enrollment_id, student_id, subject_id, schedule_id, enrolled_at, status) '
            'VALUES (@enrollment_id, @student_id, @subject_id, @schedule_id, '
            '@enrolled_at, @status)',
          ),
          parameters: record,
        );
      }
    } finally {}
  }
}
