import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/model/subject.dart';
import 'package:multi_screen_navigation/viewmodels/subject_viewmodel.dart';

class AddSubjectPage extends StatefulWidget {
  const AddSubjectPage({super.key});

  @override
  State<AddSubjectPage> createState() => _AddSubjectPageState();
}

class _AddSubjectPageState extends State<AddSubjectPage> {
  final _formKey = GlobalKey<FormState>();
  final SubjectViewmodel _viewModel = SubjectViewmodel();

  final _subjectCodeCtrl = TextEditingController();
  final _subjectNameCtrl = TextEditingController();
  final _unitsCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _subjectCodeCtrl.dispose();
    _subjectNameCtrl.dispose();
    _unitsCtrl.dispose();
    _descriptionCtrl.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final newSubject = Subject(
      subjectId: null,
      subjectCode: _subjectCodeCtrl.text.trim(),
      subjectName: _subjectNameCtrl.text.trim(),
      units: int.parse(_unitsCtrl.text.trim()),
      description: _descriptionCtrl.text.trim(),
      isAvailable: true,
    );

    final success = await _viewModel.addSubject(newSubject);

    if (mounted) {
      setState(() => _isSaving = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Subject added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_viewModel.errorMessage ?? 'Error adding subject'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Subject'),
        backgroundColor: Colors.teal,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildTextField(_subjectCodeCtrl, 'Subject Code (e.g., IT101)'),
            _buildTextField(_subjectNameCtrl, 'Subject Name'),
            _buildTextField(_unitsCtrl, 'Units', isInteger: true),
            _buildTextField(_descriptionCtrl, 'Description'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'ADD SUBJECT',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isEmail = false,
    bool isInteger = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: isInteger
            ? TextInputType.number
            : (isEmail ? TextInputType.emailAddress : TextInputType.text),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Required';
          }
          if (isInteger) {
            final int? parsed = int.tryParse(value.trim());
            if (parsed == null) {
              return 'Must be a valid integer';
            }
            if (parsed < 1 || parsed > 12) {
              return 'Units must be between 1 and 12';
            }
          }
          return null;
        },
      ),
    );
  }
}
