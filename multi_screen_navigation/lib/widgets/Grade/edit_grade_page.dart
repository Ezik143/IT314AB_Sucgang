import 'package:flutter/material.dart';

import 'package:multi_screen_navigation/model/grade.dart';
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
  late final TextEditingController _enrollmentId;
  late final TextEditingController _gradeValue;
  late final TextEditingController _remarks;
  late final TextEditingController _dateRecorded;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _enrollmentId = TextEditingController(
      text: widget.grade.enrollmentId.toString(),
    );
    _gradeValue = TextEditingController(
      text: widget.grade.gradeValue.toString(),
    );
    _remarks = TextEditingController(text: widget.grade.remarks);
    _dateRecorded = TextEditingController(text: widget.grade.dateRecorded);
  }

  @override
  void dispose() {
    _enrollmentId.dispose();
    _gradeValue.dispose();
    _remarks.dispose();
    _dateRecorded.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final success = await _viewModel.updateGrade(
      Grade(
        gradeId: widget.grade.gradeId,
        enrollmentId: int.parse(_enrollmentId.text.trim()),
        gradeValue: double.parse(_gradeValue.text.trim()),
        remarks: _remarks.text.trim(),
        dateRecorded: _dateRecorded.text.trim(),
      ),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
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
            _field(_enrollmentId, 'Enrollment ID', integer: true),
            _field(_gradeValue, 'Grade Value', decimal: true),
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

  Widget _field(
    TextEditingController controller,
    String label, {
    bool integer = false,
    bool decimal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: (integer || decimal)
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Required';
          if (integer && int.tryParse(value.trim()) == null) {
            return 'Must be a valid integer';
          }
          if (decimal && double.tryParse(value.trim()) == null) {
            return 'Must be a valid number';
          }
          return null;
        },
      ),
    );
  }
}
