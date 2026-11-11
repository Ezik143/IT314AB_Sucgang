import 'package:flutter/material.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});
  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _studentId = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _course = TextEditingController();
  int? _yearLevel;
  final TextEditingController _emailAddress = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add student")),
      body: Padding(
        padding: EdgeInsetsDirectional.all(20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _studentId,
                    decoration: InputDecoration(
                      labelText: 'Student ID',
                      hintText: 'Student ID',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter a student ID';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _fullName,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the student\'s full name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _course,
                    decoration: InputDecoration(
                      labelText: 'Course',
                      hintText: 'Course',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter the student\'s course';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<int>(
                    initialValue: _yearLevel,
                    decoration: const InputDecoration(
                      labelText: 'Year Level',
                      border: OutlineInputBorder(),
                    ),
                    items: List.generate(
                      4,
                      (index) => DropdownMenuItem<int>(
                        value: index + 1,
                        child: Text('Year ${index + 1}'),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _yearLevel = value;
                      });
                    },
                    validator: (value) {
                      return value == null
                          ? 'Please select a year level'
                          : null;
                    },
                  ),
                  TextFormField(
                    controller: _emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) {
                        return 'Please enter an email address';
                      }
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(email)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _formKey.currentState!.validate();
                    },
                    child: const Text('Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
