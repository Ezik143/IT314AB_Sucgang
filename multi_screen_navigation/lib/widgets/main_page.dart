import 'package:flutter/material.dart';
import 'package:multi_screen_navigation/widgets/Students/student_list_page.dart';
import 'package:multi_screen_navigation/widgets/Subject/subject_list_page.dart';
import 'package:multi_screen_navigation/widgets/Grade/grade_list_page.dart';
import 'package:multi_screen_navigation/widgets/Enrollment/enrollment_list_page.dart';
import 'package:multi_screen_navigation/widgets/Schedule/schedule_list_page.dart';
import 'package:multi_screen_navigation/core/db_connection.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final Future<bool> _connectionTest;

  @override
  void initState() {
    super.initState();
    _connectionTest = DatabaseService().testConnection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main'), backgroundColor: Colors.teal),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            FutureBuilder<bool>(
              future: _connectionTest,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Card(
                    child: ListTile(
                      leading: CircularProgressIndicator(),
                      title: Text('Testing database connection'),
                    ),
                  );
                }
                final connected = snapshot.data == true;
                return Card(
                  color: connected ? Colors.green : Colors.red,
                  child: ListTile(
                    leading: Icon(
                      connected ? Icons.cloud_done : Icons.cloud_off,
                      color: Colors.white,
                    ),
                    title: Text(
                      connected
                          ? 'Database connected'
                          : 'Database connection failed',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: connected
                        ? null
                        : IconButton(
                            tooltip: 'Retry connection',
                            icon: const Icon(Icons.refresh),
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                _connectionTest = DatabaseService()
                                    .testConnection();
                              });
                            },
                          ),
                  ),
                );
              },
            ),
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
