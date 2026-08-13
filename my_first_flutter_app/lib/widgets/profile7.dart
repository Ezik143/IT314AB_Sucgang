import 'package:flutter/material.dart';

class Profile8Widget extends StatefulWidget {
  const Profile8Widget({super.key});

  @override
  State<Profile8Widget> createState() => _Profile8WidgetState();
}

class _Profile8WidgetState extends State<Profile8Widget> {
  String name = "john the  cat";
  String courseAndSection = "BSIT-3";
  int age = 21;
  String hobby = "watching football";
  String height = "9'6";
  String studentStatus = "  ";
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
                    Text(
                      "Course and Section: ${courseAndSection.trim().isEmpty ? "missing" : courseAndSection}",
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

                    if (studentStatus.trim().isEmpty)
                      Text(
                        "status: mising!!!",
                        style: TextStyle(color: Colors.red),
                      )
                    else
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
