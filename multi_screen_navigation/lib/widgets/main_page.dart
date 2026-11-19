import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/widgets/Students/student_list_page.dart';
import 'package:multi_screen_navigation/widgets/Subject/subject_list_page.dart';
import 'package:multi_screen_navigation/widgets/Grade/grade_list_page.dart';
import 'package:multi_screen_navigation/widgets/Enrollment/enrollment_list_page.dart';
import 'package:multi_screen_navigation/widgets/Schedule/schedule_list_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main'), backgroundColor: Colors.teal),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentListPage()),
                );
              },
              child: Card(
                color: Colors.teal,
                child: SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: Center(
                    child: Text(
                      "Student Information",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SubjectListPage()),
                );
              },
              child: Card(
                color: Colors.teal,
                child: SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: Center(
                    child: Text(
                      "Subject",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GradeListPage(),
                  ),
                );
              },
              child: Card(
                color: Colors.teal,
                child: const SizedBox(
                  width: 300,
                  height: 150,
                  child: Center(
                    child: Text(
                      'Grades',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EnrollmentListPage(),
                  ),
                );
              },
              child: Card(
                color: Colors.teal,
                child: const SizedBox(
                  width: 300,
                  height: 150,
                  child: Center(
                    child: Text(
                      'Enrollments',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScheduleListPage(),
                  ),
                );
              },
              child: Card(
                color: Colors.teal,
                child: const SizedBox(
                  width: 300,
                  height: 150,
                  child: Center(
                    child: Text(
                      'Schedules',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
