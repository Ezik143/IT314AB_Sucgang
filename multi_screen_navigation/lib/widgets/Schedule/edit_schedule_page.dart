import 'package:flutter/material.dart';

import '../../model/schedule.dart';
import '../../model/subject.dart';
import '../../viewmodels/schedule_viewmodel.dart';
import '../../viewmodels/subject_viewmodel.dart';
import 'schedule_form_fields.dart';

class EditSchedulePage extends StatefulWidget {
  final Schedule schedule;

  const EditSchedulePage({super.key, required this.schedule});

  @override
  State<EditSchedulePage> createState() => _EditSchedulePageState();
}

class _EditSchedulePageState extends State<EditSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = ScheduleViewModel();
  final _subjectViewModel = SubjectViewmodel();
  late final TextEditingController _startTime;
  late final TextEditingController _endTime;
  late final TextEditingController _room;
  late final TextEditingController _slotCapacity;
  List<Subject> _subjects = [];
  int? _subjectId;
  late String _dayOfWeek;
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
    _subjectId = widget.schedule.subjectId;
    _dayOfWeek = widget.schedule.dayOfWeek;
    _startTime = TextEditingController(text: widget.schedule.startTime);
    _endTime = TextEditingController(text: widget.schedule.endTime);
    _room = TextEditingController(text: widget.schedule.room);
    _slotCapacity = TextEditingController(
      text: widget.schedule.slotCapacity.toString(),
    );
    _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    await _subjectViewModel.loadSubjects();
    if (!mounted) return;
    setState(() => _subjects = _subjectViewModel.subjects);
  }

  List<DropdownMenuItem<int>> _subjectItems() {
    final items = _subjects
        .where((subject) => subject.subjectId != null)
        .map(
          (subject) => DropdownMenuItem(
            value: subject.subjectId,
            child: Text('${subject.subjectCode} - ${subject.subjectName}'),
          ),
        )
        .toList();
    final currentId = widget.schedule.subjectId;
    if (!items.any((item) => item.value == currentId)) {
      items.add(
        DropdownMenuItem(
          value: currentId,
          child: Text(widget.schedule.subjectName ?? 'Subject #$currentId'),
        ),
      );
    }
    return items;
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
    final success = await _viewModel.updateSchedule(
      Schedule(
        scheduleId: widget.schedule.scheduleId,
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
          content: Text('Schedule updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage ?? 'Unable to update schedule'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Schedule'),
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
              items: _subjectItems(),
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
                  : const Text('SAVE CHANGES'),
            ),
          ],
        ),
      ),
    );
  }
}
