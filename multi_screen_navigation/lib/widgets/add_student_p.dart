import 'package:flutter/material.dart';

class AddStudentP extends StatelessWidget {
  const AddStudentP({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add student")),
      body: Padding(
        padding: EdgeInsetsDirectional.all(20),
        child: Row(children: [Text("data")]),
      ),
    );
  }
}
