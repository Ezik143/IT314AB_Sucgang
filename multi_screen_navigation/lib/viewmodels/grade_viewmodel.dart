import 'package:flutter/foundation.dart';

import 'package:multi_screen_navigation/core/error_message.dart';
import 'package:multi_screen_navigation/model/grade.dart';
import 'package:multi_screen_navigation/repositories/grade_repository.dart';

class GradeViewmodel extends ChangeNotifier {
  final GradeRepository _repository = GradeRepository();

  List<Grade> grades = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadGrades() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      grades = await _repository.getAllGrades();
    } catch (error) {
      errorMessage = friendlyError(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addGrade(Grade grade) async {
    try {
      await _repository.addGrade(grade);
      await loadGrades();
      return true;
    } catch (error) {
      errorMessage = friendlyError(error);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateGrade(Grade grade) async {
    try {
      await _repository.updateGrade(grade);
      await loadGrades();
      return true;
    } catch (error) {
      errorMessage = friendlyError(error);
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteGrade(int gradeId) async {
    try {
      await _repository.deleteGrade(gradeId);
      await loadGrades();
      return true;
    } catch (error) {
      errorMessage = friendlyError(error);
      notifyListeners();
      return false;
    }
  }
}
