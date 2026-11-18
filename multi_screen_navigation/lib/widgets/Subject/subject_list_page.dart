import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/viewmodels/subject_viewmodel.dart';
import 'package:multi_screen_navigation/widgets/Subject/add_subject_page.dart';
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
      appBar: AppBar(
        title: const Text('Subjects'),
        backgroundColor: Colors.teal,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSubjectPage()),
          );
          if (result == true && mounted) {
            await _viewModel.loadSubjects();
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
                    trailing: IconButton(
                      tooltip: 'Delete subject',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: const Text('Delete Subject'),
                            content: const Text(
                              'Are you sure you want to delete this subject?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (!context.mounted) return;
                        if (confirm != true || subject.subjectId == null) {
                          return;
                        }
                        final messenger = ScaffoldMessenger.of(context);
                        final success = await _viewModel.deleteSubject(
                          subject.subjectId!,
                        );
                        if (!mounted) return;
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? 'Subject deleted successfully!'
                                  : _viewModel.errorMessage ??
                                        'Unable to delete subject',
                            ),
                            backgroundColor: success ? Colors.green : null,
                          ),
                        );
                      },
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
