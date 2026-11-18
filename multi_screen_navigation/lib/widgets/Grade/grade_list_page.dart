import 'package:flutter/material.dart';

import 'package:multi_screen_navigation/viewmodels/grade_viewmodel.dart';
import 'package:multi_screen_navigation/widgets/Grade/grade_details_page.dart';
import 'package:multi_screen_navigation/widgets/Grade/add_grade_page.dart';

class GradeListPage extends StatefulWidget {
  const GradeListPage({super.key});

  @override
  State<GradeListPage> createState() => _GradeListPageState();
}

class _GradeListPageState extends State<GradeListPage> {
  final GradeViewmodel _viewModel = GradeViewmodel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadGrades();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grades'), backgroundColor: Colors.teal),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddGradePage()),
          );
          if (result == true && mounted) {
            await _viewModel.loadGrades();
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
                    onPressed: _viewModel.loadGrades,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (_viewModel.grades.isEmpty) {
            return const Center(child: Text('No grades'));
          }
          return RefreshIndicator(
            onRefresh: _viewModel.loadGrades,
            child: ListView.builder(
              itemCount: _viewModel.grades.length,
              itemBuilder: (context, index) {
                final grade = _viewModel.grades[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(grade.gradeValue.toStringAsFixed(0)),
                    ),
                    title: Text('Enrollment #${grade.enrollmentId}'),
                    subtitle: Text('${grade.remarks} - ${grade.dateRecorded}'),
                    onTap: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GradeDetailsPage(grade: grade),
                        ),
                      );
                      if (result == true && mounted) {
                        await _viewModel.loadGrades();
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
