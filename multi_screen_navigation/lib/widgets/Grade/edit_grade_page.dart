import 'package:flutter/material.dart';

import 'package:multi_screen_navigation/model/enrollment.dart';
import 'package:multi_screen_navigation/model/grade.dart';
import 'package:multi_screen_navigation/viewmodels/enrollment_viewmodel.dart';
import 'package:multi_screen_navigation/viewmodels/grade_viewmodel.dart';

class EditGradePage extends StatefulWidget {
  final Grade grade;

  const EditGradePage({super.key, required this.grade});

  @override
  State<EditGradePage> createState() => _EditGradePageState();
}

class _EditGradePageState extends State<EditGradePage> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = GradeViewmodel();
  final _enrollmentViewModel = EnrollmentViewModel();
  late final TextEditingController _gradeValue;
  late final TextEditingController _remarks;
  late final TextEditingController _dateRecorded;
  List<Enrollment> _enrollments = [];
  late int _enrollmentId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _enrollmentId = widget.grade.enrollmentId;
    _gradeValue = TextEditingController(
      text: widget.grade.gradeValue.toStringAsFixed(2),
    );
    _remarks = TextEditingController(text: widget.grade.remarks);
    _dateRecorded = TextEditingController(text: widget.grade.dateRecorded);
    _loadEnrollments();
  }

  Future<void> _loadEnrollments() async {
    await _enrollmentViewModel.loadEnrollments();
    if (!mounted) return;
    setState(() => _enrollments = _enrollmentViewModel.enrollments);
  }

  List<DropdownMenuItem<int>> _enrollmentItems() {
    final items = _enrollments
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
        .toList();
    if (!items.any((item) => item.value == _enrollmentId)) {
      items.add(
        DropdownMenuItem(
          value: _enrollmentId,
          child: Text('Enrollment #$_enrollmentId'),
        ),
      );
    }
    return items;
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
    final success = await _viewModel.updateGrade(
      Grade(
        gradeId: widget.grade.gradeId,
        enrollmentId: _enrollmentId,
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
          content: Text('Grade updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage ?? 'Unable to update grade'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Grade'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<int>(
              initialValue: _enrollmentId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Enrollment',
                border: OutlineInputBorder(),
              ),
              items: _enrollmentItems(),
              onChanged: (value) => setState(() => _enrollmentId = value!),
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
                  : const Text('UPDATE GRADE'),
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
