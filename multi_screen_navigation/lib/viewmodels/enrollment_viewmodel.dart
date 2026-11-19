import 'package:flutter/foundation.dart';

import '../model/enrollment.dart';
import '../repositories/enrollment_repository.dart';
import 'package:postgres/postgres.dart';

class EnrollmentViewModel extends ChangeNotifier {
  final EnrollmentRepository _repository = EnrollmentRepository();

  List<Enrollment> enrollments = [];
  bool isLoading = false;
  String? errorMessage;

  String _friendlyError(Object error) {
    if (error is ServerException) {
      switch (error.constraintName) {
        case 'uq_enrollment_student_subject':
          return 'The student is already enrolled in this subject.';
      }
    }
    return error.toString();
  }

  Future<void> loadEnrollments() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      enrollments = await _repository.getAllEnrollments();
    } catch (error) {
      errorMessage = _friendlyError(error);
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
      errorMessage = _friendlyError(error);
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
      errorMessage = _friendlyError(error);
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
      errorMessage = _friendlyError(error);
      notifyListeners();
      return false;
    }
  }
}
