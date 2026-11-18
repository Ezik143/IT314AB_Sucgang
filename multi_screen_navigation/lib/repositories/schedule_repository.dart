import 'package:postgres/postgres.dart';

import '../core/db_connection.dart';
import '../model/schedule.dart';

class ScheduleRepository {
  final DatabaseService _dbService = DatabaseService();

  static const _selectSchedules =
      'SELECT sch.schedule_id, sch.subject_id, sch.day_of_week, '
      'sch.start_time::text AS start_time, '
      'sch.end_time::text AS end_time, '
      'sch.room, sch.slot_capacity, '
      'sub.subject_code, sub.subject_name '
      'FROM schedule sch '
      'LEFT JOIN subject sub ON sub.subject_id = sch.subject_id ';

  Future<List<Schedule>> getAllSchedules() async {
    final connection = await _dbService.connectDatabase();
    final result = await connection.execute(
      '$_selectSchedules'
      'ORDER BY sch.day_of_week, sch.start_time, sch.schedule_id',
    );
    return result.map((row) => Schedule.fromRow(row.toColumnMap())).toList();
  }

  Future<List<Schedule>> getSchedulesBySubject(int subjectId) async {
    final connection = await _dbService.connectDatabase();
    final result = await connection.execute(
      Sql.named(
        '$_selectSchedules WHERE sch.subject_id = @subject_id '
        'ORDER BY sch.day_of_week, sch.start_time, sch.schedule_id',
      ),
      parameters: {'subject_id': subjectId},
    );
    return result.map((row) => Schedule.fromRow(row.toColumnMap())).toList();
  }

  Future<Schedule?> getScheduleById(int scheduleId) async {
    final connection = await _dbService.connectDatabase();
    final result = await connection.execute(
      Sql.named('$_selectSchedules WHERE sch.schedule_id = @schedule_id'),
      parameters: {'schedule_id': scheduleId},
    );
    if (result.isEmpty) return null;
    return Schedule.fromRow(result.first.toColumnMap());
  }

  Future<void> addSchedule(Schedule schedule) async {
    final connection = await _dbService.connectDatabase();
    await connection.execute(
      Sql.named(
        'INSERT INTO schedule '
        '(subject_id, day_of_week, start_time, end_time, room, slot_capacity) '
        'VALUES (@subject_id, @day_of_week, @start_time, @end_time, '
        '@room, @slot_capacity)',
      ),
      parameters: schedule.toParams(),
    );
  }

  Future<void> updateSchedule(Schedule schedule) async {
    if (schedule.scheduleId == null) {
      throw ArgumentError('Schedule ID is required for updating.');
    }
    final connection = await _dbService.connectDatabase();
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
      parameters: {...schedule.toParams(), 'schedule_id': schedule.scheduleId},
    );
  }

  Future<void> deleteSchedule(int scheduleId) async {
    final connection = await _dbService.connectDatabase();
    await connection.execute(
      Sql.named('DELETE FROM schedule WHERE schedule_id = @schedule_id'),
      parameters: {'schedule_id': scheduleId},
    );
  }
}
