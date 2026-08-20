import 'package:flutter/material.dart';
import 'package:my_first_flutter_app/Models/student.dart';
import 'package:my_first_flutter_app/data/student_data.dart';

class StudentCard extends StatefulWidget {
  Student student;
  final VoidCallback onDelete;

  StudentCard({super.key, required this.student, required this.onDelete});

  @override
  State<StudentCard> createState() => _StudentCardState();
}

class _StudentCardState extends State<StudentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87,

      child: InkWell(
        splashColor: Colors.lightGreen,
        onTap: () {
          debugPrint("click click r");
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(widget.student.imagePath),
              ),

              if (widget.student.isFavorite == true)
                Icon(Icons.favorite, color: Colors.red),

              SizedBox(height: 20),
              Text(
                'Name: ${widget.student.name}',
                style: TextStyle(color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                'Course: ${widget.student.course}',
                style: TextStyle(color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                'Year Level: ${widget.student.yearLevel}',
                style: TextStyle(color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                'Age: ${widget.student.age}',
                style: TextStyle(color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                'Hobby: ${widget.student.hobby}',
                style: TextStyle(color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                'Student ID: ${widget.student.studentId}',
                style: TextStyle(color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                'Email: ${widget.student.email}',
                style: TextStyle(color: Colors.teal),
              ),
              SizedBox(height: 10),
              Text(
                'Favorite Subject: ${widget.student.favoriteSubject}',
                style: TextStyle(color: Colors.teal),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.student.isFavorite = true;
                  });
                },
                child: Text("Favorite"),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("edit"),
                      content: Text("you are now editing something"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("witwiw"),
                        ),
                      ],
                    ),
                  );
                },
                child: Text("Edit"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.student.age++;
                  });
                },
                child: Icon(Icons.plus_one),
              ),
              ElevatedButton(onPressed: widget.onDelete, child: Text("Delete")),
            ],
          ),
        ),
      ),
    );
  }
}
