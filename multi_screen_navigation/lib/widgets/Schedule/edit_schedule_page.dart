import 'package:flutter/material.dart';

import '../../model/schedule.dart';
import '../../viewmodels/schedule_viewmodel.dart';
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
  late final TextEditingController _subjectId;
  late final TextEditingController _dayOfWeek;
  late final TextEditingController _startTime;
  late final TextEditingController _endTime;
  late final TextEditingController _room;
  late final TextEditingController _slotCapacity;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _subjectId = TextEditingController(
      text: widget.schedule.subjectId.toString(),
    );
    _dayOfWeek = TextEditingController(text: widget.schedule.dayOfWeek);
    _startTime = TextEditingController(text: widget.schedule.startTime);
    _endTime = TextEditingController(text: widget.schedule.endTime);
    _room = TextEditingController(text: widget.schedule.room);
    _slotCapacity = TextEditingController(
      text: widget.schedule.slotCapacity.toString(),
    );
  }

  @override
  void dispose() {
    _subjectId.dispose();
    _dayOfWeek.dispose();
    _startTime.dispose();
    _endTime.dispose();
    _room.dispose();
    _slotCapacity.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    final success = await _viewModel.updateSchedule(
      Schedule(
        scheduleId: widget.schedule.scheduleId,
        subjectId: int.parse(_subjectId.text.trim()),
        dayOfWeek: _dayOfWeek.text.trim(),
        startTime: _startTime.text.trim(),
        endTime: _endTime.text.trim(),
        room: _room.text.trim(),
        slotCapacity: int.parse(_slotCapacity.text.trim()),
      ),
    );
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
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
            ScheduleFormFields.integerField(_subjectId, 'Subject ID'),
            ScheduleFormFields.textField(_dayOfWeek, 'Day of Week'),
            ScheduleFormFields.textField(_startTime, 'Start Time (HH:mm:ss)'),
            ScheduleFormFields.textField(_endTime, 'End Time (HH:mm:ss)'),
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
