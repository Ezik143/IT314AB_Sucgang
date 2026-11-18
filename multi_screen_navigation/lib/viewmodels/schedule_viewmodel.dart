import 'package:flutter/foundation.dart';

import '../core/error_message.dart';
import '../model/schedule.dart';
import '../repositories/schedule_repository.dart';

class ScheduleViewModel extends ChangeNotifier {
  final ScheduleRepository _repository = ScheduleRepository();

  List<Schedule> schedules = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadSchedules() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      schedules = await _repository.getAllSchedules();
    } catch (error) {
      errorMessage = friendlyError(error);
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
      errorMessage = friendlyError(error);
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
      errorMessage = friendlyError(error);
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
      errorMessage = friendlyError(error);
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
      errorMessage = friendlyError(error);
      notifyListeners();
      return false;
    }
  }
}
