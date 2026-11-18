import 'package:flutter/foundation.dart';

import '../model/enrollment.dart';
import '../repositories/enrollment_repository.dart';

class EnrollmentViewModel extends ChangeNotifier {
  final EnrollmentRepository _repository = EnrollmentRepository();

  List<Enrollment> enrollments = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadEnrollments() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      await _repository.seedEnrollments();
      enrollments = await _repository.getAllEnrollments();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addEnrollment(Enrollment enrollment) async {
    try {
      await _repository.addEnrollment(enrollment);
      await loadEnrollments();
      return true;
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEnrollment(Enrollment enrollment) async {
    try {
      await _repository.updateEnrollment(enrollment);
      await loadEnrollments();
      return true;
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEnrollment(int enrollmentId) async {
    try {
      await _repository.deleteEnrollment(enrollmentId);
      await loadEnrollments();
      return true;
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
      return false;
    }
  }
}
