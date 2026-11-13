import 'package:flutter/foundation.dart';
import 'package:multi_screen_navigation/Models/student.dart';
import 'package:multi_screen_navigation/repositories/student_repository.dart';

class StudentViewModel extends ChangeNotifier {
  final StudentRepository _repository = StudentRepository();

  List<Student> _students = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Student> get students => _students;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadStudents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _students = await _repository.getAllStudents();
    } catch (error) {
      _errorMessage = 'Failed to load students. Check connection.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
