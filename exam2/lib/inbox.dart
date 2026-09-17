import 'package:exam2/main.dart';
import 'package:exam2/model.dart';
import 'package:flutter/material.dart';

class InboxWidget extends StatelessWidget {
  Player players;
  InboxWidget({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black, onPressed: () {}),
          actions: [Text(players.name, style: TextStyle(color: Colors.black))],
        ),

        body: Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: Column(children: [TextField()]),
        ),
      ),
    );
    // return Padding(padding: EdgeInsetsGeometry.all(20),child: Column());
  }
}
