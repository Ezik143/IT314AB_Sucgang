import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/widgets/student_model.dart';

class StudentListScreenW extends StatelessWidget {
  final Student student;
  const StudentListScreenW({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black38,
      child: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              "/student-details",
              arguments: student,
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(radius: 50),
              SizedBox(height: 20),
              Text(
                'student ID: ${student.studentId}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'name: ${student.name}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'year level: ${student.yearLevel}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'course: ${student.course}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'hobby: ${student.hobby}',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Text(
                'favorite subject: ${student.favoriteSubject}',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
