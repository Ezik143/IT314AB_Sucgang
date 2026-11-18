import 'package:flutter/material.dart';

import '../../viewmodels/schedule_viewmodel.dart';
import 'add_schedule_page.dart';
import 'schedule_details_page.dart';

class ScheduleListPage extends StatefulWidget {
  const ScheduleListPage({super.key});

  @override
  State<ScheduleListPage> createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  final ScheduleViewModel _viewModel = ScheduleViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadSchedules();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedules'),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddSchedulePage()),
          );
          if (result == true && mounted) {
            await _viewModel.loadSchedules();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (_viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _viewModel.loadSchedules,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (_viewModel.schedules.isEmpty) {
            return const Center(child: Text('No schedules'));
          }
          return RefreshIndicator(
            onRefresh: _viewModel.loadSchedules,
            child: ListView.builder(
              itemCount: _viewModel.schedules.length,
              itemBuilder: (context, index) {
                final schedule = _viewModel.schedules[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(schedule.scheduleId.toString()),
                    ),
                    title: Text(
                      '${schedule.subjectCode ?? 'Subject'}: '
                      '${schedule.subjectName ?? 'Unknown subject'}',
                    ),
                    subtitle: Text(
                      '${schedule.dayOfWeek}, ${schedule.startTime}-'
                      '${schedule.endTime} - ${schedule.room}',
                    ),
                    onTap: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ScheduleDetailsPage(schedule: schedule),
                        ),
                      );
                      if (result == true && mounted) {
                        await _viewModel.loadSchedules();
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
