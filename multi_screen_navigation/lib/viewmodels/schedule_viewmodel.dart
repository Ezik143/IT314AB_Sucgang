import 'package:flutter/foundation.dart';

import '../model/schedule.dart';
import '../repositories/schedule_repository.dart';
import 'package:postgres/postgres.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleRepository _repository = ScheduleRepository();

  List<Schedule> schedules = [];
  bool isLoading = false;
  String? errorMessage;

  String _friendlyError(Object error) {
    if (error is ServerException) {
      switch (error.constraintName) {
        case 'chk_schedule_time':
          return 'End time must be later than the start time.';
        case 'chk_schedule_day':
          return 'Day must be Monday to Sunday.';
        case 'chk_schedule_slot_capacity':
          return 'Slot capacity must be greater than zero.';
      }
    }
    return error.toString();
  }

  Future<void> loadSchedules() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      schedules = await _repository.getAllSchedules();
    } catch (error) {
      errorMessage = _friendlyError(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSchedulesForSubject(int subjectId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      schedules = await _repository.getSchedulesBySubject(subjectId);
    } catch (error) {
      errorMessage = _friendlyError(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addSchedule(Schedule schedule) async {
    try {
      await _repository.addSchedule(schedule);
      await loadSchedules();
      return true;
    } catch (error) {
      errorMessage = _friendlyError(error);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSchedule(Schedule schedule) async {
    try {
      await _repository.updateSchedule(schedule);
      await loadSchedules();
      return true;
    } catch (error) {
      errorMessage = _friendlyError(error);
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSchedule(int scheduleId) async {
    try {
      await _repository.deleteSchedule(scheduleId);
      await loadSchedules();
      return true;
    } catch (error) {
      errorMessage = _friendlyError(error);
      notifyListeners();
      return false;
    }
  }
}
