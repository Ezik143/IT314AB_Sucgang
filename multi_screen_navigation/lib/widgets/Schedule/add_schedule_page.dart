import 'package:flutter/material.dart';

import '../../model/schedule.dart';
import '../../viewmodels/schedule_viewmodel.dart';
import 'schedule_form_fields.dart';

class AddSchedulePage extends StatefulWidget {
  const AddSchedulePage({super.key});

  @override
  State<AddSchedulePage> createState() => _AddSchedulePageState();
}

class _AddSchedulePageState extends State<AddSchedulePage> {
  final _formKey = GlobalKey<FormState>();
  final _viewModel = ScheduleViewModel();
  final _subjectId = TextEditingController();
  final _dayOfWeek = TextEditingController();
  final _startTime = TextEditingController();
  final _endTime = TextEditingController();
  final _room = TextEditingController();
  final _slotCapacity = TextEditingController();
  bool _isSaving = false;

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
    final success = await _viewModel.addSchedule(
      Schedule(
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
                  : const Text('ADD SCHEDULE'),
            ),
          ],
        ),
      ),
    );
  }
}
