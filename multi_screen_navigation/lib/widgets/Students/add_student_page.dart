import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/Models/student.dart';
import 'package:multi_screen_navigation/viewmodels/student_viewmodel.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final _formKey = GlobalKey<FormState>();
  final StudentViewModel _viewModel = StudentViewModel();

  final _studentNumberCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _courseCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  int _yearLevel = 1;

  bool _isSaving = false;

  @override
  void dispose() {
    _studentNumberCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _courseCtrl.dispose();
    _contactCtrl.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final newStudent = Student(
      studentNumber: _studentNumberCtrl.text.trim(),
      firstName: _firstNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      course: _courseCtrl.text.trim(),
      yearLevel: _yearLevel,
      contactNumber: _contactCtrl.text.trim(),
      createdAt: '',
    );

    final success = await _viewModel.addStudent(newStudent);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Student added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_viewModel.errorMessage ?? 'Error adding student'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Student'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(
              _studentNumberCtrl,
              'Student Number (e.g., 2023-001)',
            ),
            _buildTextField(_firstNameCtrl, 'First Name'),
            _buildTextField(_lastNameCtrl, 'Last Name'),
            _buildTextField(_emailCtrl, 'Email Address', isEmail: true),
            _buildTextField(_courseCtrl, 'Course (e.g., BSIT)'),
            _buildTextField(_contactCtrl, 'Contact Number'),
            const SizedBox(height: 10),
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
              onPressed: _isSaving ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'SAVE STUDENT',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
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
          return null;
        },
      ),
    );
  }
}
