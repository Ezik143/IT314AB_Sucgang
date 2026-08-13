import 'package:flutter/material.dart';

class Profile3Widget extends StatefulWidget {
  const Profile3Widget({super.key});

  @override
  State<Profile3Widget> createState() => _Profile3WidgetState();
}

class _Profile3WidgetState extends State<Profile3Widget> {
  String name = "clint brondo";
  String courseAndSection = "BSME-1";
  int age = 45;
  String hobby = "DOING Exercise";
  String height = "5'5";
  String studentStatus = "inactive/drop";
  String avatarPic = "asset/images/cat3.jpg";

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
                    Text("Name: $name", style: TextStyle(color: Colors.teal)),
                    SizedBox(width: 10, height: 20),

                    SizedBox(width: 10, height: 10),
                    Text("Age: $age", style: TextStyle(color: Colors.teal)),

                    SizedBox(width: 10, height: 10),
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

                    Text("Hobby: $hobby", style: TextStyle(color: Colors.teal)),

                    SizedBox(width: 10, height: 20),

                    Text(
                      "Height: $height",
                      style: TextStyle(color: Colors.teal),
                    ),

                    SizedBox(width: 10, height: 20),

                    Text(
                      "status $studentStatus",
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
