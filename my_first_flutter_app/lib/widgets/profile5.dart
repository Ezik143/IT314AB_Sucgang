import 'package:flutter/material.dart';

class Profile6Widget extends StatefulWidget {
  const Profile6Widget({super.key});

  @override
  State<Profile6Widget> createState() => _Profile6WidgetState();
}

class _Profile6WidgetState extends State<Profile6Widget> {
  String name = "john the  cat";
  String courseAndSection = " ";
  int age = 21;
  String hobby = "watching football";
  String height = "9'6";
  String studentStatus = "active";
  String avatarPic = "asset/images/Cat.jpg";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //profile
            Card(
              color: Colors.black87,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(avatarPic),
                    ),

                    SizedBox(width: 10, height: 20),
                    Text(
                      "Name: ${name.trim().isEmpty ? "missing" : name}",
                      style: TextStyle(color: Colors.teal),
                    ),
                    SizedBox(width: 10, height: 20),

                    SizedBox(width: 10, height: 10),
                    Text(
                      "Age: ${age == 0 ? "missing" : age}",
                      style: TextStyle(color: Colors.teal),
                    ),

                    SizedBox(width: 10, height: 10),

                    if (courseAndSection.trim().isEmpty)
                      Text(
                        "Course and Section: missing",
                        style: TextStyle(color: Colors.red),
                      )
                    else
                      Text(
                        "Course and Section: $courseAndSection",
                        style: TextStyle(color: Colors.teal),
                      ),

                    SizedBox(width: 10, height: 10),
                    Text(
                      "Thursday, July 30, 2026",
                      style: TextStyle(color: Colors.teal),
                    ),

                    SizedBox(width: 10, height: 20),

                    Text(
                      "Hobby: ${hobby.trim().isEmpty ? "missing" : hobby}",
                      style: TextStyle(color: Colors.teal),
                    ),

                    SizedBox(width: 10, height: 20),

                    Text(
                      "Height: ${height.trim().isEmpty ? "missing" : height}t",
                      style: TextStyle(color: Colors.teal),
                    ),

                    SizedBox(width: 10, height: 20),

                    Text(
                      "status ${studentStatus.trim().isEmpty ? "missing" : studentStatus}",
                      style: TextStyle(color: Colors.teal),
                    ),

                    SizedBox(width: 10, height: 20),

                    Row(
                      children: [
                        Text("pizza", style: TextStyle(color: Colors.teal)),
                        SizedBox(width: 10, height: 20),
                        Text("burger", style: TextStyle(color: Colors.teal)),
                      ],
                    ),

                    SizedBox(width: 10, height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
