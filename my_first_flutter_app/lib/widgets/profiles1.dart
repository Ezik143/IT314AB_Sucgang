import 'package:flutter/material.dart';

class Profile2Widget extends StatefulWidget {
  const Profile2Widget({super.key});

  @override
  State<Profile2Widget> createState() => _Profile2WidgetState();
}

class _Profile2WidgetState extends State<Profile2Widget> {
  String name = "john the  dog";
  String courseAndSection = "BSIT-2";
  int age = 21;
  String hobby = "reading";
  String height = "10'2";
  String studentStatus = "active";
  String avatarPic = "asset/images/cat2.jpg";

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
