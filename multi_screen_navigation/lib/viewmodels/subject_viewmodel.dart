import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/model/subject.dart';
import 'package:multi_screen_navigation/repositories/subject_repository.dart';

class SubjectViewmodel extends ChangeNotifier {
  final SubjectRepository _repository = SubjectRepository();

  List<Subject> subjects = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadSubjects() async {
    isLoading = true;
    notifyListeners();
    try {
      subjects = await _repository.getAllSubjects();
    } catch (error) {
      errorMessage = error.toString();
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
      errorMessage = error.toString();
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
      errorMessage = error.toString();
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
      errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }
}
