import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/model/subject.dart';
import 'package:multi_screen_navigation/viewmodels/subject_viewmodel.dart';

class EditSubjectPage extends StatefulWidget {
  final Subject subject;

  const EditSubjectPage({super.key, required this.subject});

  @override
  State<EditSubjectPage> createState() => _EditSubjectPageState();
}

class _EditSubjectPageState extends State<EditSubjectPage> {
  final SubjectViewmodel _viewModel = SubjectViewmodel();

  final _formKey = GlobalKey<FormState>();

  late TextEditingController _subjectCode;
  late TextEditingController _subjectName;
  late TextEditingController _units;
  late TextEditingController _description;

  late int _yearLevel;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final subject = widget.subject;

    _subjectCode = TextEditingController(text: subject.subjectCode);
    _subjectName = TextEditingController(text: subject.subjectName);
    _units = TextEditingController(text: subject.units.toString());
    _description = TextEditingController(text: subject.description);
  }

  @override
  void dispose() {
    _subjectCode.dispose();
    _subjectName.dispose();
    _units.dispose();
    _description.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _updateSubject() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedSubject = Subject(
      subjectId: widget.subject.subjectId,
      subjectCode: _subjectCode.text.trim(),
      subjectName: _subjectName.text.trim(),
      units: int.parse(_units.text.trim()),
      description: _description.text.trim(),
      isAvailable: widget.subject.isAvailable,
    );

    final success = await _viewModel.updateSubject(updatedSubject);

    if (!mounted) return;

    setState(() => _isSaving = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_viewModel.errorMessage ?? 'Update failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Subject'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _field(_subjectCode, 'Subject Code'),
            _field(_subjectName, 'Subject Name'),
            _field(_units, 'Units'),
            _field(_description, 'Description'),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _isSaving ? null : _updateSubject,
              child: _isSaving
                  ? const CircularProgressIndicator()
                  : const Text('UPDATE SUBJECT'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }
}