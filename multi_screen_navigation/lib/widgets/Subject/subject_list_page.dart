import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/viewmodels/subject_viewmodel.dart';
import 'package:multi_screen_navigation/widgets/Subject/subject_details_page.dart';

class SubjectListPage extends StatefulWidget {
  const SubjectListPage({super.key});

  @override
  State<SubjectListPage> createState() => _SubjectListPageState();
}

class _SubjectListPageState extends State<SubjectListPage> {
  final SubjectViewmodel _viewModel = SubjectViewmodel();

  @override
  void initState() {
    super.initState();
    _viewModel.loadSubjects();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Subjects')),
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
                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                  SizedBox(height: 10),
                  Text(
                    _viewModel.errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _viewModel.loadSubjects();
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_viewModel.subjects.isEmpty) {
            return Center(child: Text('No subjects'));
          }

          return RefreshIndicator(
            onRefresh: _viewModel.loadSubjects,
            child: ListView.builder(
              itemCount: _viewModel.subjects.length,
              itemBuilder: (context, index) {
                final subject = _viewModel.subjects[index];

                return Card(
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.book)),
                    title: Text(subject.subjectName),
                    subtitle: Text(
                      '${subject.subjectCode} - ${subject.units} Units',
                    ),
                    trailing: Text(
                      subject.isAvailable ? 'Available' : 'not available',
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SubjectDetailsPage(subject: subject),
                        ),
                      );
                      if (result == true && mounted) {
                        await _viewModel.loadSubjects();
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
