import 'package:flutter/foundation.dart';
import 'package:multi_screen_navigation/core/error_message.dart';
import 'package:multi_screen_navigation/model/enrollment.dart';
import 'package:multi_screen_navigation/model/grade.dart';
import 'package:multi_screen_navigation/model/student.dart';
import 'package:multi_screen_navigation/repositories/enrollment_repository.dart';
import 'package:multi_screen_navigation/repositories/grade_repository.dart';
import 'package:multi_screen_navigation/repositories/student_repository.dart';

class StudentViewModel extends ChangeNotifier {
  final StudentRepository _repository = StudentRepository();

  List<Student> students = [];
  bool isLoading = false;
  String? errorMessage;
  List<Enrollment> enrollments = [];
  List<Grade> grades = [];

  Future<void> loadStudents() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      students = await _repository.getAllStudents();
    } catch (error) {
      errorMessage = friendlyError(error);
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
      errorMessage = friendlyError(error);
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
      errorMessage = friendlyError(error);
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
      errorMessage = friendlyError(error);
      notifyListeners();
      return false;
    }
  }

  Future<void> loadStudentRecords(int studentId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      enrollments = await EnrollmentRepository().getEnrollmentsByStudent(
        studentId,
      );
      grades = await GradeRepository().getGradesByStudent(studentId);
    } catch (error) {
      errorMessage = friendlyError(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
