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
  final TextEditingController _yearLevel = TextEditingController();
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
                  ),
                  TextFormField(
                    controller: _fullName,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _course,
                    decoration: InputDecoration(
                      labelText: 'Course',
                      hintText: 'Course',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _yearLevel,
                    decoration: InputDecoration(
                      labelText: 'Year Level',
                      hintText: 'Year Level',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    controller: _emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      hintText: 'Email Address',
                      border: OutlineInputBorder(),
                    ),
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
