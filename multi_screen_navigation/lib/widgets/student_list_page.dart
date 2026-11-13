import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/viewmodels/student_viewmodel.dart';
import 'package:multi_screen_navigation/widgets/student_details_page.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final StudentViewModel _viewModel = StudentViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadStudents();
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
        title: const Text('Student Directory'),
        backgroundColor: Colors.blueAccent,
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
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 10),
                  Text(
                    _viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _viewModel.loadStudents,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_viewModel.students.isEmpty) {
            return const Center(
              child: Text('No students found in the database.'),
            );
          }

          return RefreshIndicator(
            onRefresh: _viewModel.loadStudents,
            child: ListView.builder(
              itemCount: _viewModel.students.length,
              itemBuilder: (context, index) {
                final student = _viewModel.students[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text('${student.firstName} ${student.lastName}'),
                    subtitle: Text(
                      '${student.course} - Year ${student.yearLevel}',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StudentDetailsPage(student: student),
                        ),
                      );
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
