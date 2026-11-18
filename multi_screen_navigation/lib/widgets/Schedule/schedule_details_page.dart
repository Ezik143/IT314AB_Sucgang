import 'package:flutter/material.dart';

import '../../model/schedule.dart';
import '../../viewmodels/schedule_viewmodel.dart';
import 'edit_schedule_page.dart';

class ScheduleDetailsPage extends StatelessWidget {
  final Schedule schedule;

  const ScheduleDetailsPage({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    final viewModel = ScheduleViewModel();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Details'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditSchedulePage(schedule: schedule),
                ),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Schedule'),
                  content: const Text('Delete this schedule record?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
              if (confirm != true || !context.mounted) return;
              if (schedule.scheduleId == null) return;
              final success = await viewModel.deleteSchedule(
                schedule.scheduleId!,
              );
              viewModel.dispose();
              if (!context.mounted) return;
              if (success) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      viewModel.errorMessage ?? 'Unable to delete schedule',
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _row('Schedule ID', '#${schedule.scheduleId}'),
                const Divider(),
                _row(
                  'Subject',
                  '${schedule.subjectCode ?? ''} '
                      '${schedule.subjectName ?? 'Unknown subject'} '
                      '(ID: ${schedule.subjectId})',
                ),
                const Divider(),
                _row('Day', schedule.dayOfWeek),
                const Divider(),
                _row('Start Time', schedule.startTime),
                const Divider(),
                _row('End Time', schedule.endTime),
                const Divider(),
                _row('Room', schedule.room),
                const Divider(),
                _row('Slot Capacity', schedule.slotCapacity.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
