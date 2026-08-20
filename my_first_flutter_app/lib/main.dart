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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: students.isEmpty
          ? EmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return StudentCard(
                  student: student,

                  onDelete: () {
                    setState(() {
                      students.removeAt(index);
                    });
                  },
                );
              },
            ),
    );
  }
}
