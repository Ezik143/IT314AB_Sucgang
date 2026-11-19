import 'package:flutter/foundation.dart';
import 'package:multi_screen_navigation/model/subject.dart';
import 'package:multi_screen_navigation/repositories/subject_repository.dart';
import 'package:postgres/postgres.dart';

class SubjectViewmodel extends ChangeNotifier {
  final SubjectRepository _repository = SubjectRepository();

  List<Subject> subjects = [];
  bool isLoading = false;
  String? errorMessage;

  String _friendlyError(Object error) {
    if (error is ServerException) {
      switch (error.constraintName) {
        case 'uq_subject_subject_code':
          return 'A subject with this subject code already exists.';
        case 'chk_subject_units':
          return 'Units must be between 1 and 12.';
      }
    }
    return error.toString();
  }

  Future<void> loadSubjects() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      subjects = await _repository.getAllSubjects();
    } catch (error) {
      errorMessage = _friendlyError(error);
    }
    isLoading = false;
    notifyListeners();
  }

  Future<bool> addSubject(Subject subject) async {
    try {
      await _repository.addSubject(subject);
      await loadSubjects();
      return true;
    } catch (error) {
      errorMessage = _friendlyError(error);
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateSubject(Subject subject) async {
    try {
      await _repository.updateSubject(subject);
      await loadSubjects();
      return true;
    } catch (error) {
      errorMessage = _friendlyError(error);
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteSubject(int subjectId) async {
    try {
      await _repository.deleteSubject(subjectId);
      await loadSubjects();
      return true;
    } catch (error) {
      errorMessage = _friendlyError(error);
      notifyListeners();
      return false;
    }
  }
}
