import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/widgets/add_student_p.dart';
import 'package:multi_screen_navigation/widgets/student_data.dart';
import 'package:multi_screen_navigation/widgets/student_list_screen_w.dart';
import 'package:multi_screen_navigation/widgets/student_model.dart';
import 'package:multi_screen_navigation/widgets/student_page.dart';

void main() {
  runApp(MainApp(student: students.first));
}

class MainApp extends StatelessWidget {
  final Student student;
  const MainApp({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/studentList": (context) => StudentListScreenW(student: student),
        "/student-details": (context) => StudentPage(student: student),
        "/add-student": (context) => AddStudentP(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Student List')),
            body: Padding(
              padding: EdgeInsetsGeometry.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/add-student");
                    },
                    child: Text("Add students"),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return StudentListScreenW(student: student);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
