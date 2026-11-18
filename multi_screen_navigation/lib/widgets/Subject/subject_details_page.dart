import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/model/subject.dart';
import 'package:multi_screen_navigation/viewmodels/subject_viewmodel.dart';
import 'package:multi_screen_navigation/widgets/Subject/edit_subject_page.dart';

class SubjectDetailsPage extends StatelessWidget {
  final Subject subject;

  const SubjectDetailsPage({super.key, required this.subject});

  @override
  Widget build(BuildContext context) {
    final viewModel = SubjectViewmodel();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditSubjectPage(subject: subject),
                ),
              );

              if (result == true && context.mounted) {
                viewModel.loadSubjects();
                Navigator.pop(context, true);
              }
            },
            icon: const Icon(Icons.update),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Subject'),
                  content: const Text(
                    'Are you sure you want to delete this subject?',
                  ),
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

              final success = subject.subjectId != null
                  ? await viewModel.deleteSubject(subject.subjectId!)
                  : false;

              viewModel.dispose();

              if (!context.mounted) return;

              if (success) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete subject')),
                );
              }
            },
          ),
        ],
        title: const Text('Subject Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal,
                child: Icon(Icons.book, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                subject.subjectName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                subject.subjectCode,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Subject Code', subject.subjectCode),
                    const Divider(),
                    _buildDetailRow('Units', '${subject.units} Units'),
                    const Divider(),
                    _buildDetailRow('Description', subject.description),
                    const Divider(),
                    _buildDetailRow(
                      'Availability',
                      subject.isAvailable ? 'Available' : 'Not Available',
                    ),
                    const Divider(),
                    _buildDetailRow('Created', subject.description),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(child: Text(value)),
      ],
    );
  }
}
