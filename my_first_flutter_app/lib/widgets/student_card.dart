import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/Models/student.dart';

class StudentCard extends StatelessWidget {
  final Student student;

  const StudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(student.imagePath),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: ${student.name}',
              style: const TextStyle(color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text(
              'Course: ${student.course}',
              style: const TextStyle(color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text(
              'Year Level: ${student.yearLevel}',
              style: const TextStyle(color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text(
              'Age: ${student.age}',
              style: const TextStyle(color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text(
              'Hobby: ${student.hobby}',
              style: const TextStyle(color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text(
              'Student ID: ${student.studentId}',
              style: const TextStyle(color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text(
              'Email: ${student.email}',
              style: const TextStyle(color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text(
              'Favorite Subject: ${student.favoriteSubject}',
              style: const TextStyle(color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}