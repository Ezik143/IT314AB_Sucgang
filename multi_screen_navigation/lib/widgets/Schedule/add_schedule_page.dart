import 'package:flutter/material.dart';

import '../../model/schedule.dart';
import '../../model/subject.dart';
import '../../viewmodels/schedule_viewmodel.dart';
import '../../viewmodels/subject_viewmodel.dart';
import 'schedule_form_fields.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = ScheduleViewModel();
  final _subjectViewModel = SubjectViewmodel();
  final _startTime = TextEditingController(text: '08:00');
  final _endTime = TextEditingController(text: '10:00');
  final _room = TextEditingController();
  final _slotCapacity = TextEditingController();
  List<Subject> _subjects = [];
  int? _subjectId;
  String _dayOfWeek = 'Monday';
  bool _isSaving = false;

  static const _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    await _subjectViewModel.loadSubjects();
    if (!mounted) return;
    setState(() => _subjects = _subjectViewModel.subjects);
  }

  @override
  void dispose() {
    _startTime.dispose();
    _endTime.dispose();
    _room.dispose();
    _slotCapacity.dispose();
    _viewModel.dispose();
    _subjectViewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final start = ScheduleFormFields.normalizeTime(_startTime.text);
    final end = ScheduleFormFields.normalizeTime(_endTime.text);
    if (end.compareTo(start) <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time.')),
      );
      return;
    }
    setState(() => _isSaving = true);
    final success = await _viewModel.addSchedule(
      Schedule(
        subjectId: _subjectId!,
        dayOfWeek: _dayOfWeek,
        startTime: start,
        endTime: end,
        room: _room.text.trim(),
        slotCapacity: int.parse(_slotCapacity.text.trim()),
      ),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Schedule added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage ?? 'Unable to add schedule'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Schedule'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
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
                      child: Text(
                        '${subject.subjectCode} - ${subject.subjectName}',
                      ),
                    ),
                  )
                  .toList(),
              validator: (value) => value == null ? 'Required' : null,
              onChanged: (value) => setState(() => _subjectId = value),
            ),
            const SizedBox(height: 15),
            DropdownButtonFormField<String>(
              initialValue: _dayOfWeek,
              decoration: const InputDecoration(
                labelText: 'Day of Week',
                border: OutlineInputBorder(),
              ),
              items: _days
                  .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                  .toList(),
              onChanged: (value) => setState(() => _dayOfWeek = value!),
            ),
            const SizedBox(height: 15),
            ScheduleFormFields.timeField(_startTime, 'Start Time (HH:mm)'),
            ScheduleFormFields.timeField(_endTime, 'End Time (HH:mm)'),
            ScheduleFormFields.textField(_room, 'Room'),
            ScheduleFormFields.integerField(_slotCapacity, 'Slot Capacity'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _submit,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('ADD SCHEDULE'),
            ),
          ],
        ),
      ),
    );
  }
}
