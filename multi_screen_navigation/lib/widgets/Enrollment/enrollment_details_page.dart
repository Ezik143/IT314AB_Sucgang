import 'package:flutter/material.dart';

import '../../model/enrollment.dart';
import '../../viewmodels/enrollment_viewmodel.dart';
import 'edit_enrollment_page.dart';

class EnrollmentDetailsPage extends StatelessWidget {
  final Enrollment enrollment;

  const EnrollmentDetailsPage({super.key, required this.enrollment});

  @override
  Widget build(BuildContext context) {
    final viewModel = EnrollmentViewModel();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enrollment Details'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditEnrollmentPage(enrollment: enrollment),
                ),
              );
              if (result == true && context.mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            tooltip: 'Drop enrollment',
            icon: const Icon(Icons.cancel),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Drop Enrollment'),
                  content: const Text(
                    'Change this enrollment status to Dropped?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Drop'),
                    ),
                  ],
                ),
              );
              if (confirm != true || !context.mounted) return;
              if (enrollment.enrollmentId == null) return;
              final success = await viewModel.deleteEnrollment(
                enrollment.enrollmentId!,
              );
              viewModel.dispose();
              if (!context.mounted) return;
              if (success) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      viewModel.errorMessage ?? 'Unable to delete enrollment',
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
                _row('Enrollment ID', '#${enrollment.enrollmentId}'),
                const Divider(),
                _row(
                  'Student',
                  '${enrollment.studentName ?? 'Unknown student'} '
                      '(ID: ${enrollment.studentId})',
                ),
                const Divider(),
                _row(
                  'Subject',
                  '${enrollment.subjectCode ?? ''} '
                      '${enrollment.subjectName ?? 'Unknown subject'} '
                      '(ID: ${enrollment.subjectId})',
                ),
                const Divider(),
                _row(
                  'Schedule',
                  '${enrollment.scheduleDescription ?? 'Unknown schedule'} '
                      '(ID: ${enrollment.scheduleId})',
                ),
                const Divider(),
                _row('Enrolled At', enrollment.enrolledAt),
                const Divider(),
                _row('Status', enrollment.status),
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
