import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/model/student.dart';
import 'package:multi_screen_navigation/viewmodels/student_viewmodel.dart';

class EditStudentPage extends StatefulWidget {
  final Student student;

  const EditStudentPage({super.key, required this.student});

  @override
  State<EditStudentPage> createState() => _EditStudentPageState();
}

class _EditStudentPageState extends State<EditStudentPage> {
  final StudentViewModel _viewModel = StudentViewModel();

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _studentNumber;
  late TextEditingController _firstName;
  late TextEditingController _lastName;
  late TextEditingController _email;
  late TextEditingController _course;
  late TextEditingController _contact;

  late int _yearLevel;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final student = widget.student;

    _studentNumber = TextEditingController(text: student.studentNumber);
    _firstName = TextEditingController(text: student.firstName);
    _lastName = TextEditingController(text: student.lastName);
    _email = TextEditingController(text: student.email);
    _course = TextEditingController(text: student.course);
    _contact = TextEditingController(text: student.contactNumber);

    _yearLevel = student.yearLevel;
  }

  @override
  void dispose() {
    _studentNumber.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _course.dispose();
    _contact.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _updateStudent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedStudent = Student(
      studentId: widget.student.studentId,
      studentNumber: _studentNumber.text.trim(),
      firstName: _firstName.text.trim(),
      lastName: _lastName.text.trim(),
      email: _email.text.trim(),
      course: _course.text.trim(),
      yearLevel: _yearLevel,
      contactNumber: _contact.text.trim(),
      createdAt: widget.student.createdAt,
    );

    final success = await _viewModel.updateStudent(updatedStudent);

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_viewModel.errorMessage ?? 'Update failed')),
      );
    }
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
          if (isEmail &&
              !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
            return 'Enter a valid email address';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_studentNumber, 'Student Number'),
            _field(_firstName, 'First Name'),
            _field(_lastName, 'Last Name'),
            _field(_email, 'Email', isEmail: true),
            _field(_course, 'Course'),
            _field(_contact, 'Contact Number'),

            DropdownButtonFormField<int>(
              initialValue: _yearLevel,
              decoration: const InputDecoration(
                labelText: 'Year Level',
                border: OutlineInputBorder(),
              ),
              items: [1, 2, 3, 4].map((year) {
                return DropdownMenuItem(value: year, child: Text('Year $year'));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _yearLevel = value);
                }
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isSaving ? null : _updateStudent,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('UPDATE STUDENT'),
            ),
          ],
        ),
      ),
    );
  }
}
