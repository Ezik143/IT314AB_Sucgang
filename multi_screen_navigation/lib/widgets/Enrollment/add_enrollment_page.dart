import 'package:flutter/material.dart';

import '../../model/enrollment.dart';
import '../../model/schedule.dart';
import '../../model/student.dart';
import '../../model/subject.dart';
import '../../viewmodels/enrollment_viewmodel.dart';
import '../../viewmodels/schedule_viewmodel.dart';
import '../../viewmodels/student_viewmodel.dart';
import '../../viewmodels/subject_viewmodel.dart';

class AddEnrollmentPage extends StatefulWidget {
  const AddEnrollmentPage({super.key});

  @override
  State<AddEnrollmentPage> createState() => _AddEnrollmentPageState();
}

class _AddEnrollmentPageState extends State<AddEnrollmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = EnrollmentViewModel();
  final _studentViewModel = StudentViewModel();
  final _subjectViewModel = SubjectViewmodel();
  final _scheduleViewModel = ScheduleViewModel();
  List<Student> _students = [];
  List<Subject> _subjects = [];
  List<Schedule> _schedules = [];
  int? _studentId;
  int? _subjectId;
  int? _scheduleId;
  final _enrolledAt = TextEditingController(
    text: DateTime.now()
        .toIso8601String()
        .replaceAll('T', ' ')
        .split('.')
        .first,
  );
  bool _isSaving = false;
  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    await Future.wait([
      _studentViewModel.loadStudents(),
      _subjectViewModel.loadSubjects(),
      _scheduleViewModel.loadSchedules(),
    ]);
    if (!mounted) return;
    setState(() {
      _students = _studentViewModel.students;
      _subjects = _subjectViewModel.subjects;
      _schedules = _scheduleViewModel.schedules;
    });
  }

  @override
  void dispose() {
    _enrolledAt.dispose();
    _viewModel.dispose();
    _studentViewModel.dispose();
    _subjectViewModel.dispose();
    _scheduleViewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final success = await _viewModel.addEnrollment(
      Enrollment(
        studentId: _studentId!,
        subjectId: _subjectId!,
        scheduleId: _scheduleId!,
        enrolledAt: _enrolledAt.text.trim(),
        status: 'Enrolled',
      ),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enrollment saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage ?? 'Unable to add enrollment'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Enrollment'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<int>(
              initialValue: _studentId,
              decoration: const InputDecoration(
                labelText: 'Student',
                border: OutlineInputBorder(),
              ),
              items: _students
                  .where((student) => student.studentId != null)
                  .map(
                    (student) => DropdownMenuItem(
                      value: student.studentId,
                      child: Text('${student.firstName} ${student.lastName}'),
                    ),
                  )
                  .toList(),
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) => setState(() => _studentId = value),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<int>(
              initialValue: _subjectId,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              items: _subjects
                  .where((subject) => subject.subjectId != null)
                  .map(
                    (subject) => DropdownMenuItem(
                      value: subject.subjectId,
                      child: Text(subject.subjectName),
                    ),
                  )
                  .toList(),
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) {
                setState(() {
                  _subjectId = value;
                  _scheduleId = null;
                });
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<int>(
              initialValue: _scheduleId,
              decoration: const InputDecoration(
                labelText: 'Schedule',
                border: OutlineInputBorder(),
              ),
              items: _schedules
                  .where(
                    (schedule) =>
                        schedule.scheduleId != null &&
                        schedule.subjectId == _subjectId,
                  )
                  .map(
                    (schedule) => DropdownMenuItem(
                      value: schedule.scheduleId,
                      child: Text(
                        '${schedule.dayOfWeek} '
                        '${schedule.startTime}-${schedule.endTime} '
                        '${schedule.room}',
                      ),
                    ),
                  )
                  .toList(),
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) => setState(() => _scheduleId = value),
            ),
            const SizedBox(height: 15),
            _textField(_enrolledAt, 'Enrolled At (YYYY-MM-DD HH:mm:ss)'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _submit,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('ADD ENROLLMENT'),
            ),
          ],
        ),
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
