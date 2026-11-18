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
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _viewModel.loadGrades();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = _isSearching
        ? TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            decoration: const InputDecoration(
              hintText: 'Search student name',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
            ),
            onChanged: (_) => setState(() {}),
          )
        : const Text('Grades');

    return Scaffold(
      appBar: AppBar(
        title: title,
        backgroundColor: Colors.teal,
        actions: [
          if (_isSearching)
            IconButton(
              tooltip: 'Clear search',
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() {});
              },
            )
          else
            IconButton(
              tooltip: 'Search students',
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _isSearching = true),
            ),
          if (_isSearching)
            IconButton(
              tooltip: 'Close search',
              icon: const Icon(Icons.close),
              onPressed: () {
                _searchController.clear();
                setState(() => _isSearching = false);
              },
            ),
        ],
      ),
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
          final query = _searchController.text.trim().toLowerCase();
          final grades = _viewModel.grades.where((grade) {
            return (grade.studentName ?? '').toLowerCase().contains(query);
          }).toList();
          if (grades.isEmpty) {
            return const Center(
              child: Text('No grades found for this student'),
            );
          }
          return RefreshIndicator(
            onRefresh: _viewModel.loadGrades,
            child: ListView.builder(
              itemCount: grades.length,
              itemBuilder: (context, index) {
                final grade = grades[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(grade.gradeValue.toStringAsFixed(0)),
                    ),
                    title: Text(grade.studentName ?? 'Unknown student'),
                    subtitle: Text(
                      '${grade.subjectCode ?? 'Subject'}: '
                      '${grade.subjectName ?? 'Unknown subject'} - '
                      'Grade ${grade.gradeValue.toStringAsFixed(0)} '
                      '(${grade.remarks})',
                    ),
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
