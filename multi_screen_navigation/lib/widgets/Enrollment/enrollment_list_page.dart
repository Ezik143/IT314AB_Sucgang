import 'package:flutter/material.dart';

import '../../viewmodels/enrollment_viewmodel.dart';
import 'add_enrollment_page.dart';
import 'enrollment_details_page.dart';

class EnrollmentListPage extends StatefulWidget {
  const EnrollmentListPage({super.key});

  @override
  State<EnrollmentListPage> createState() => _EnrollmentListPageState();
}

class _EnrollmentListPageState extends State<EnrollmentListPage> {
  final EnrollmentViewModel _viewModel = EnrollmentViewModel();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _viewModel.loadEnrollments();
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
        : const Text('Enrollments');

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
            MaterialPageRoute(builder: (_) => const AddEnrollmentPage()),
          );
          if (result == true && mounted) {
            await _viewModel.loadEnrollments();
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
                    onPressed: _viewModel.loadEnrollments,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (_viewModel.enrollments.isEmpty) {
            return const Center(child: Text('No enrollments'));
          }
          final query = _searchController.text.trim().toLowerCase();
          final enrollments = _viewModel.enrollments.where((enrollment) {
            return (enrollment.studentName ?? '').toLowerCase().contains(query);
          }).toList();
          if (enrollments.isEmpty) {
            return const Center(
              child: Text('No enrollments found for this student'),
            );
          }
          return RefreshIndicator(
            onRefresh: _viewModel.loadEnrollments,
            child: ListView.builder(
              itemCount: enrollments.length,
              itemBuilder: (context, index) {
                final enrollment = enrollments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(enrollment.enrollmentId.toString()),
                    ),
                    title: Text(
                      '${enrollment.studentName ?? 'Student'} - '
                      '${enrollment.subjectCode ?? 'Subject'}: '
                      '${enrollment.subjectName ?? 'Unknown subject'}',
                    ),
                    subtitle: Text(
                      '${enrollment.scheduleDescription ?? 'Schedule unavailable'} '
                      '- ${enrollment.status}',
                    ),
                    onTap: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              EnrollmentDetailsPage(enrollment: enrollment),
                        ),
                      );
                      if (result == true && mounted) {
                        await _viewModel.loadEnrollments();
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
