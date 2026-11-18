import 'package:flutter/material.dart';

import 'package:multi_screen_navigation/model/enrollment.dart';
import 'package:multi_screen_navigation/model/grade.dart';
import 'package:multi_screen_navigation/viewmodels/enrollment_viewmodel.dart';
import 'package:multi_screen_navigation/viewmodels/grade_viewmodel.dart';

class AddGradePage extends StatefulWidget {
  const AddGradePage({super.key});

  @override
  State<AddGradePage> createState() => _AddGradePageState();
}

class _AddGradePageState extends State<AddGradePage> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = GradeViewmodel();
  final _enrollmentViewModel = EnrollmentViewModel();
  final _gradeValue = TextEditingController();
  final _remarks = TextEditingController();
  final _dateRecorded = TextEditingController(
    text: DateTime.now().toIso8601String().split('T').first,
  );
  List<Enrollment> _enrollments = [];
  int? _enrollmentId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadEnrollments();
  }

  Future<void> _loadEnrollments() async {
    await _enrollmentViewModel.loadEnrollments();
    if (!mounted) return;
    setState(() {
      _enrollments = _enrollmentViewModel.enrollments
          .where((enrollment) => enrollment.status == 'Enrolled')
          .toList();
    });
  }

  @override
  void dispose() {
    _gradeValue.dispose();
    _remarks.dispose();
    _dateRecorded.dispose();
    _viewModel.dispose();
    _enrollmentViewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final success = await _viewModel.addGrade(
      Grade(
        enrollmentId: _enrollmentId!,
        gradeValue: double.parse(_gradeValue.text.trim()),
        remarks: _remarks.text.trim(),
        dateRecorded: _dateRecorded.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Grade added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage ?? 'Unable to add grade'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Grade'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<int>(
              initialValue: _enrollmentId,
              decoration: const InputDecoration(
                labelText: 'Enrollment',
                border: OutlineInputBorder(),
              ),
              items: _enrollments
                  .where((enrollment) => enrollment.enrollmentId != null)
                  .map(
                    (enrollment) => DropdownMenuItem(
                      value: enrollment.enrollmentId,
                      child: Text(
                        '${enrollment.studentName ?? 'Student'} - '
                        '${enrollment.subjectCode ?? 'Subject'}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) => setState(() => _enrollmentId = value),
            ),
            const SizedBox(height: 15),
            _gradeField(),
            _field(_remarks, 'Remarks'),
            _field(_dateRecorded, 'Date Recorded (YYYY-MM-DD)'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _submit,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('ADD GRADE'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradeField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: _gradeValue,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(
          labelText: 'Grade Value (1.00 - 5.00)',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Required';
          final parsed = double.tryParse(value.trim());
          if (parsed == null) return 'Must be a valid number';
          if (parsed < 1.0 || parsed > 5.0) {
            return 'Grade must be between 1.00 and 5.00';
          }
          return null;
        },
      ),
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) =>
            value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}
