import 'package:flutter/material.dart';

import '../../model/enrollment.dart';
import '../../model/schedule.dart';
import '../../model/student.dart';
import '../../model/subject.dart';
import '../../viewmodels/enrollment_viewmodel.dart';
import '../../viewmodels/schedule_viewmodel.dart';
import '../../viewmodels/student_viewmodel.dart';
import '../../viewmodels/subject_viewmodel.dart';

class EditEnrollmentPage extends StatefulWidget {
  final Enrollment enrollment;

  const EditEnrollmentPage({super.key, required this.enrollment});

  @override
  State<EditEnrollmentPage> createState() => _EditEnrollmentPageState();
}

class _EditEnrollmentPageState extends State<EditEnrollmentPage> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = EnrollmentViewModel();
  final _studentViewModel = StudentViewModel();
  final _subjectViewModel = SubjectViewmodel();
  final _scheduleViewModel = ScheduleViewModel();
  List<Student> _students = [];
  List<Subject> _subjects = [];
  List<Schedule> _schedules = [];
  late int _studentId;
  late int _subjectId;
  late int _scheduleId;
  late final TextEditingController _enrolledAt;
  late String _status;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _studentId = widget.enrollment.studentId;
    _subjectId = widget.enrollment.subjectId;
    _scheduleId = widget.enrollment.scheduleId;
    _enrolledAt = TextEditingController(text: widget.enrollment.enrolledAt);
    _status = widget.enrollment.status;
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
    final success = await _viewModel.updateEnrollment(
      Enrollment(
        enrollmentId: widget.enrollment.enrollmentId,
        studentId: _studentId,
        subjectId: _subjectId,
        scheduleId: _scheduleId,
        enrolledAt: _enrolledAt.text.trim(),
        status: _status,
      ),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enrollment updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
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
    final schedulesForSubject = _schedules
        .where((schedule) => schedule.subjectId == _subjectId)
        .toList();
    final studentItems = _students
        .where((student) => student.studentId != null)
        .map(
          (student) => DropdownMenuItem(
            value: student.studentId,
            child: Text('${student.firstName} ${student.lastName}'),
          ),
        )
        .toList();
    if (!studentItems.any((item) => item.value == _studentId)) {
      studentItems.add(
        DropdownMenuItem(
          value: _studentId,
          child: Text('Student #$_studentId'),
        ),
      );
    }
    final subjectItems = _subjects
        .where((subject) => subject.subjectId != null)
        .map(
          (subject) => DropdownMenuItem(
            value: subject.subjectId,
            child: Text(subject.subjectName),
          ),
        )
        .toList();
    if (!subjectItems.any((item) => item.value == _subjectId)) {
      subjectItems.add(
        DropdownMenuItem(
          value: _subjectId,
          child: Text('Subject #$_subjectId'),
        ),
      );
    }
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
            DropdownButtonFormField<int>(
              initialValue: _studentId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Student',
                border: OutlineInputBorder(),
              ),
              items: studentItems,
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) => setState(() => _studentId = value!),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<int>(
              initialValue: _subjectId,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              items: subjectItems,
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) {
                setState(() {
                  _subjectId = value!;
                  final matches = _schedules
                      .where((schedule) => schedule.subjectId == _subjectId)
                      .toList();
                  if (matches.isNotEmpty) {
                    _scheduleId = matches.first.scheduleId!;
                  }
                });
              },
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<int>(
              initialValue:
                  schedulesForSubject.any(
                    (schedule) => schedule.scheduleId == _scheduleId,
                  )
                  ? _scheduleId
                  : null,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Schedule',
                border: OutlineInputBorder(),
              ),
              items: schedulesForSubject
                  .where((schedule) => schedule.scheduleId != null)
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
              onChanged: (value) => setState(() => _scheduleId = value!),
            ),
            const SizedBox(height: 15),
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
