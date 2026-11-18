import 'package:flutter/material.dart';

import 'package:multi_screen_navigation/model/grade.dart';
import 'package:multi_screen_navigation/viewmodels/grade_viewmodel.dart';
import 'package:multi_screen_navigation/widgets/Grade/edit_grade_page.dart';

class GradeDetailsPage extends StatelessWidget {
  final Grade grade;

  const GradeDetailsPage({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    final viewModel = GradeViewmodel();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade Details'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push<bool>(
                context,
                MaterialPageRoute(builder: (_) => EditGradePage(grade: grade)),
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
                  title: const Text('Delete Grade'),
                  content: const Text('Delete this grade record?'),
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
              if (grade.gradeId == null) return;
              final success = await viewModel.deleteGrade(grade.gradeId!);
              viewModel.dispose();
              if (!context.mounted) return;
              if (success) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      viewModel.errorMessage ?? 'Unable to delete grade',
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
                _row('Enrollment ID', grade.enrollmentId.toString()),
                const Divider(),
                _row('Grade', grade.gradeValue.toString()),
                const Divider(),
                _row('Remarks', grade.remarks),
                const Divider(),
                _row('Date Recorded', grade.dateRecorded),
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
