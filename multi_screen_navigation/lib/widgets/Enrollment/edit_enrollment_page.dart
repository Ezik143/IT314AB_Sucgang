import 'package:flutter/material.dart';

import '../../model/enrollment.dart';
import '../../viewmodels/enrollment_viewmodel.dart';

class EditEnrollmentPage extends StatefulWidget {
  final Enrollment enrollment;

  const EditEnrollmentPage({super.key, required this.enrollment});

  @override
  State<EditEnrollmentPage> createState() => _EditEnrollmentPageState();
}

class _EditEnrollmentPageState extends State<EditEnrollmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = EnrollmentViewModel();
  late final TextEditingController _studentId;
  late final TextEditingController _subjectId;
  late final TextEditingController _scheduleId;
  late final TextEditingController _enrolledAt;
  late String _status;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _studentId = TextEditingController(
      text: widget.enrollment.studentId.toString(),
    );
    _subjectId = TextEditingController(
      text: widget.enrollment.subjectId.toString(),
    );
    _scheduleId = TextEditingController(
      text: widget.enrollment.scheduleId.toString(),
    );
    _enrolledAt = TextEditingController(text: widget.enrollment.enrolledAt);
    _status = widget.enrollment.status;
  }

  @override
  void dispose() {
    _studentId.dispose();
    _subjectId.dispose();
    _scheduleId.dispose();
    _enrolledAt.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final success = await _viewModel.updateEnrollment(
      Enrollment(
        enrollmentId: widget.enrollment.enrollmentId,
        studentId: int.parse(_studentId.text.trim()),
        subjectId: int.parse(_subjectId.text.trim()),
        scheduleId: int.parse(_scheduleId.text.trim()),
        enrolledAt: _enrolledAt.text.trim(),
        status: _status,
      ),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _viewModel.errorMessage ?? 'Unable to update enrollment',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Enrollment'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _integerField(_studentId, 'Student ID'),
            _integerField(_subjectId, 'Subject ID'),
            _integerField(_scheduleId, 'Schedule ID'),
            _textField(_enrolledAt, 'Enrolled At (YYYY-MM-DD HH:mm:ss)'),
            DropdownButtonFormField<String>(
              initialValue: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Enrolled', child: Text('Enrolled')),
                DropdownMenuItem(value: 'Dropped', child: Text('Dropped')),
              ],
              onChanged: (value) => setState(() => _status = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _submit,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('SAVE CHANGES'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _integerField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Required';
          if (int.tryParse(value.trim()) == null) {
            return 'Must be a valid integer';
          }
          return null;
        },
      ),
    );
  }

  Widget _textField(TextEditingController controller, String label) {
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
