import 'package:flutter/material.dart';

import 'package:multi_screen_navigation/model/grade.dart';
import 'package:multi_screen_navigation/viewmodels/grade_viewmodel.dart';

class AddGradePage extends StatefulWidget {
  const AddGradePage({super.key});

  @override
  State<AddGradePage> createState() => _AddGradePageState();
}

class _AddGradePageState extends State<AddGradePage> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = GradeViewmodel();
  final _enrollmentId = TextEditingController();
  final _gradeValue = TextEditingController();
  final _remarks = TextEditingController();
  final _dateRecorded = TextEditingController(
    text: DateTime.now().toIso8601String().split('T').first,
  );
  bool _isSaving = false;

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
    final success = await _viewModel.addGrade(
      Grade(
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
            _field(_enrollmentId, 'Enrollment ID', integer: true),
            _field(_gradeValue, 'Grade Value', decimal: true),
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
