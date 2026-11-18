import 'package:flutter/foundation.dart';
import 'package:multi_screen_navigation/model/student.dart';
import 'package:multi_screen_navigation/repositories/student_repository.dart';

class StudentViewModel extends ChangeNotifier {
  final StudentRepository _repository = StudentRepository();

  List<Student> students = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadStudents() async {
    isLoading = true;
    notifyListeners();

    try {
      students = await _repository.getAllStudents();
    } catch (error) {
      errorMessage = error.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> addStudent(Student student) async {
    try {
      await _repository.addStudent(student);
      await loadStudents();
      return true;
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateStudent(Student student) async {
    try {
      await _repository.updateStudent(student);
      await loadStudents();
      return true;
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteStudent(int studentId) async {
    try {
      await _repository.deleteStudent(studentId);
      await loadStudents();
      return true;
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }
}
