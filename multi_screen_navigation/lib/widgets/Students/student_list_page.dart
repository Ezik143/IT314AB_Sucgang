import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/Models/student.dart';
import 'package:multi_screen_navigation/viewmodels/student_viewmodel.dart';
import 'package:multi_screen_navigation/widgets/Students/add_student_page.dart';
import 'package:multi_screen_navigation/widgets/Students/student_details_page.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final StudentViewModel _viewModel = StudentViewModel();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _viewModel.loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  List<Student> get _filteredStudents {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) {
      return _viewModel.students;
    }

    return _viewModel.students.where((student) {
      final name = '${student.firstName} ${student.lastName}'.toLowerCase();
      return name.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search student name',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : const Text('Student Directory'),
        actions: [
          IconButton(
            tooltip: _isSearching ? 'Close search' : 'Search students',
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStudentPage()),
          );
          if (result == true && mounted) {
            await _viewModel.loadStudents();
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          final filteredStudents = _filteredStudents;

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

          if (filteredStudents.isEmpty) {
            return Center(
              child: Text(
                _searchQuery.isEmpty
                    ? 'No students found in the database.'
                    : 'No students match your search.',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _viewModel.loadStudents,
            child: ListView.builder(
              itemCount: filteredStudents.length,
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
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
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              StudentDetailsPage(student: student),
                        ),
                      );
                      if (result == true && mounted) {
                        await _viewModel.loadStudents();
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
