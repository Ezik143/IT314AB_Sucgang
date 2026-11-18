import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/model/student.dart';
import 'package:multi_screen_navigation/viewmodels/student_viewmodel.dart';
import 'package:multi_screen_navigation/widgets/Students/edit_student_page.dart';

class StudentDetailsPage extends StatefulWidget {
  final Student student;

  const StudentDetailsPage({super.key, required this.student});

  @override
  State<StudentDetailsPage> createState() => _StudentDetailsPageState();
}

class _StudentDetailsPageState extends State<StudentDetailsPage> {
  final StudentViewModel _viewModel = StudentViewModel();

  @override
  void initState() {
    super.initState();
    if (widget.student.studentId != null) {
      _viewModel.loadStudentRecords(widget.student.studentId!);
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final student = widget.student;
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
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ListenableBuilder(
                  listenable: _viewModel,
                  builder: (context, child) {
                    if (_viewModel.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (_viewModel.errorMessage != null) {
                      return Text(
                        _viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Enrolled Subjects',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        if (_viewModel.enrollments.isEmpty)
                          const Text('No enrollments')
                        else
                          ..._viewModel.enrollments.map(
                            (enrollment) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                '${enrollment.subjectCode ?? 'Subject'}: '
                                '${enrollment.subjectName ?? 'Unknown subject'}',
                              ),
                              subtitle: Text(
                                '${enrollment.scheduleDescription ?? 'Schedule unavailable'} '
                                '- ${enrollment.status}',
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        const Text(
                          'Grades',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(),
                        if (_viewModel.grades.isEmpty)
                          const Text('No grades')
                        else
                          ..._viewModel.grades.map(
                            (grade) => ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(grade.gradeValue.toStringAsFixed(2)),
                              subtitle: Text(
                                '${grade.subjectCode ?? 'Subject'}: '
                                '${grade.subjectName ?? 'Unknown subject'} - '
                                'Grade ${grade.gradeValue.toStringAsFixed(0)} '
                                '(${grade.remarks})',
                              ),
                            ),
                          ),
                      ],
                    );
                  },
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
