import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../model/schedule.dart';

class ScheduleRepository {
  final DatabaseService _dbService = DatabaseService();

  Future<List<Schedule>> getAllSchedules() async {
    final connection = await _dbService.connectDatabase();
    try {
      final result = await connection.execute(
        'SELECT sch.*, sub.subject_code, sub.subject_name '
        'FROM schedule sch '
        'LEFT JOIN subject sub ON sub.subject_id = sch.subject_id '
        'ORDER BY sch.day_of_week, sch.start_time, sch.schedule_id',
      );
      return result.map((row) => Schedule.fromRow(row.toColumnMap())).toList();
    } finally {}
  }

  Future<Schedule?> getScheduleById(int scheduleId) async {
    final connection = await _dbService.connectDatabase();
    try {
      final result = await connection.execute(
        Sql.named(
          'SELECT sch.*, sub.subject_code, sub.subject_name '
          'FROM schedule sch '
          'LEFT JOIN subject sub ON sub.subject_id = sch.subject_id '
          'WHERE sch.schedule_id = @schedule_id',
        ),
        parameters: {'schedule_id': scheduleId},
      );
      if (result.isEmpty) return null;
      return Schedule.fromRow(result.first.toColumnMap());
    } finally {}
  }

  Future<void> addSchedule(Schedule schedule) async {
    final connection = await _dbService.connectDatabase();
    try {
      await connection.execute(
        Sql.named(
          'INSERT INTO schedule '
          '(subject_id, day_of_week, start_time, end_time, room, slot_capacity) '
          'VALUES (@subject_id, @day_of_week, @start_time, @end_time, '
          '@room, @slot_capacity)',
        ),
        parameters: schedule.toParams(),
      );
    } finally {}
  }

  Future<void> updateSchedule(Schedule schedule) async {
    if (schedule.scheduleId == null) {
      throw ArgumentError('Schedule ID is required for updating.');
    }
    final connection = await _dbService.connectDatabase();
    try {
      await connection.execute(
        Sql.named(
          'UPDATE schedule SET '
          'subject_id = @subject_id, '
          'day_of_week = @day_of_week, '
          'start_time = @start_time, '
          'end_time = @end_time, '
          'room = @room, '
          'slot_capacity = @slot_capacity '
          'WHERE schedule_id = @schedule_id',
        ),
        parameters: {
          ...schedule.toParams(),
          'schedule_id': schedule.scheduleId,
        },
      );
    } finally {}
  }

  Future<void> deleteSchedule(int scheduleId) async {
    final connection = await _dbService.connectDatabase();
    try {
      await connection.execute(
        Sql.named('DELETE FROM schedule WHERE schedule_id = @schedule_id'),
        parameters: {'schedule_id': scheduleId},
      );
    } finally {}
  }

  Future<void> seedSchedules() async {
    const records = <Map<String, Object>>[
      {
        'schedule_id': 1,
        'subject_id': 1,
        'day_of_week': 'Monday',
        'start_time': '08:00:00',
        'end_time': '10:00:00',
        'room': 'Room 101',
        'slot_capacity': 5,
      },
      {
        'schedule_id': 2,
        'subject_id': 1,
        'day_of_week': 'Tuesday',
        'start_time': '10:00:00',
        'end_time': '12:00:00',
        'room': 'Room 102',
        'slot_capacity': 5,
      },
      {
        'schedule_id': 3,
        'subject_id': 2,
        'day_of_week': 'Monday',
        'start_time': '10:00:00',
        'end_time': '12:00:00',
        'room': 'Lab 201',
        'slot_capacity': 4,
      },
      {
        'schedule_id': 4,
        'subject_id': 3,
        'day_of_week': 'Wednesday',
        'start_time': '08:00:00',
        'end_time': '10:00:00',
        'room': 'Lab 202',
        'slot_capacity': 5,
      },
      {
        'schedule_id': 5,
        'subject_id': 4,
        'day_of_week': 'Wednesday',
        'start_time': '10:00:00',
        'end_time': '12:00:00',
        'room': 'Lab 203',
        'slot_capacity': 4,
      },
      {
        'schedule_id': 6,
        'subject_id': 5,
        'day_of_week': 'Thursday',
        'start_time': '08:00:00',
        'end_time': '10:00:00',
        'room': 'Lab 204',
        'slot_capacity': 5,
      },
      {
        'schedule_id': 7,
        'subject_id': 6,
        'day_of_week': 'Thursday',
        'start_time': '10:00:00',
        'end_time': '12:00:00',
        'room': 'Lab 205',
        'slot_capacity': 5,
      },
      {
        'schedule_id': 8,
        'subject_id': 7,
        'day_of_week': 'Friday',
        'start_time': '08:00:00',
        'end_time': '10:00:00',
        'room': 'Room 103',
        'slot_capacity': 6,
      },
      {
        'schedule_id': 9,
        'subject_id': 8,
        'day_of_week': 'Friday',
        'start_time': '10:00:00',
        'end_time': '12:00:00',
        'room': 'Room 104',
        'slot_capacity': 6,
      },
      {
        'schedule_id': 10,
        'subject_id': 2,
        'day_of_week': 'Tuesday',
        'start_time': '13:00:00',
        'end_time': '15:00:00',
        'room': 'Lab 201',
        'slot_capacity': 4,
      },
    ];

    final connection = await _dbService.connectDatabase();
    try {
      for (final record in records) {
        final existing = await connection.execute(
          Sql.named(
            'SELECT schedule_id FROM schedule '
            'WHERE schedule_id = @schedule_id',
          ),
          parameters: {'schedule_id': record['schedule_id']},
        );
        if (existing.isNotEmpty) continue;

        await connection.execute(
          Sql.named(
            'INSERT INTO schedule '
            '(schedule_id, subject_id, day_of_week, start_time, end_time, '
            'room, slot_capacity) '
            'VALUES (@schedule_id, @subject_id, @day_of_week, @start_time, '
            '@end_time, @room, @slot_capacity)',
          ),
          parameters: record,
        );
      }
    } finally {}
  }
}
