import '../core/formatting.dart';

class Schedule {
  final int? scheduleId;
  final int subjectId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;
  final int slotCapacity;
  final String? subjectCode;
  final String? subjectName;

  Schedule({
    this.scheduleId,
    required this.subjectId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.slotCapacity,
    this.subjectCode,
    this.subjectName,
  });

  factory Schedule.fromRow(dynamic row) {
    return Schedule(
      scheduleId: row['schedule_id'],
      subjectId: row['subject_id'],
      dayOfWeek: row['day_of_week'],
      startTime: formatClock(row['start_time']),
      endTime: formatClock(row['end_time']),
      room: row['room'],
      slotCapacity: row['slot_capacity'],
      subjectCode: row['subject_code']?.toString(),
      subjectName: row['subject_name']?.toString(),
    );
  }

  Map<String, dynamic> toParams() {
    return {
      'subject_id': subjectId,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'room': room,
      'slot_capacity': slotCapacity,
    };
  }
}
