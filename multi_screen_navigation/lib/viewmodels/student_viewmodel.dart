import 'package:flutter/foundation.dart';
import 'package:multi_screen_navigation/model/enrollment.dart';
import 'package:multi_screen_navigation/model/grade.dart';
import 'package:multi_screen_navigation/model/student.dart';
import 'package:multi_screen_navigation/repositories/enrollment_repository.dart';
import 'package:multi_screen_navigation/repositories/grade_repository.dart';
import 'package:multi_screen_navigation/repositories/student_repository.dart';
import 'package:postgres/postgres.dart';

class StudentViewModel extends ChangeNotifier {
  final StudentRepository _repository = StudentRepository();

  List<Student> students = [];
  bool isLoading = false;
  String? errorMessage;
  List<Enrollment> enrollments = [];
  List<Grade> grades = [];

  String _friendlyError(Object error) {
    if (error is ServerException) {
      switch (error.constraintName) {
        case 'uq_student_email':
          return 'A student with this email address already exists.';
        case 'uq_student_student_number':
          return 'A student with this student number already exists.';
        case 'chk_student_year_level':
          return 'Year level must be between 1 and 4.';
      }
    }
    return error.toString();
  }

  Future<void> loadStudents() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      students = await _repository.getAllStudents();
    } catch (error) {
      errorMessage = _friendlyError(error);
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
      errorMessage = _friendlyError(error);
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
      errorMessage = _friendlyError(error);
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
      errorMessage = _friendlyError(error);
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
      errorMessage = _friendlyError(error);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
