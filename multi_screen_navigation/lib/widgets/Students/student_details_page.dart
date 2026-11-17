import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/Models/student.dart';
import 'package:multi_screen_navigation/viewmodels/student_viewmodel.dart';
import 'package:multi_screen_navigation/widgets/Students/edit_student_page.dart';

class StudentDetailsPage extends StatelessWidget {
  final Student student;

  const StudentDetailsPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            color: Colors.white,
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditStudentPage(student: student),
                ),
              );

              if (result == true && context.mounted) {
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
                  title: const Text('Delete Student'),
                  content: const Text(
                    'Are you sure you want to delete this student?',
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

              final viewModel = StudentViewModel();
              final success = student.studentId != null
                  ? await viewModel.deleteStudent(student.studentId!)
                  : false;

              viewModel.dispose();

              if (!context.mounted) return;

              if (success) {
                Navigator.pop(context, true);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to delete student')),
                );
              }
            },
          ),
        ],
        title: const Text('Student Details'),
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
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                '${student.firstName} ${student.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Center(
              child: Text(
                student.studentNumber,
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
                    _buildDetailRow('Email', student.email),
                    const Divider(),
                    _buildDetailRow('Course', student.course),
                    const Divider(),
                    _buildDetailRow('Year Level', '${student.yearLevel}'),
                    const Divider(),
                    _buildDetailRow(
                      'Contact',
                      student.contactNumber.isEmpty
                          ? 'N/A'
                          : student.contactNumber,
                    ),
                    const Divider(),
                    _buildDetailRow('Created', student.createdAt),
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
