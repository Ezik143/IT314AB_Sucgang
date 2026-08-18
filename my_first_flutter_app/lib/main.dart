import 'package:flutter/material.dart';
import 'data/student_data.dart';
import 'widgets/student_card.dart';
import 'widgets/empty_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'my first flutter app',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.teal)),
      home: const MyHomePage(title: 'Students List'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: students.isEmpty
          ? const EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return StudentCard(student: student);
              },
            ),
    );
  }
}
