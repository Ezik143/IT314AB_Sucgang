import 'package:flutter/foundation.dart';

import 'package:multi_screen_navigation/model/grade.dart';
import 'package:multi_screen_navigation/repositories/grade_repository.dart';
import 'package:postgres/postgres.dart';

class GradeViewmodel extends ChangeNotifier {
  final GradeRepository _repository = GradeRepository();

  List<Grade> grades = [];
  bool isLoading = false;
  String? errorMessage;

  String _friendlyError(Object error) {
    if (error is ServerException) {
      switch (error.constraintName) {
        case 'uq_grades_enrollment_id':
          return 'This enrollment already has a grade. Edit the existing grade instead.';
        case 'chk_grades_grade_value':
          return 'Grade must be between 1.00 and 5.00.';
      }
    }
    return error.toString();
  }

  Future<void> loadGrades() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      grades = await _repository.getAllGrades();
    } catch (error) {
      errorMessage = _friendlyError(error);
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
      errorMessage = _friendlyError(error);
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
      errorMessage = _friendlyError(error);
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
      errorMessage = _friendlyError(error);
      notifyListeners();
      return false;
    }
  }
}
