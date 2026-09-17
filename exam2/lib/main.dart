import 'package:exam2/data.dart';
import 'package:exam2/model.dart';
import 'package:exam2/widget/anotherWidget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MainApp(players: players));
}

class MainApp extends StatelessWidget {
  final List<Player> players;

  const MainApp({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {"/default": (context) => Anotherwidget(players: players.first)},
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          brightness: Brightness.dark,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.black,
          title: Text(
            "Social",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(8),
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return Anotherwidget(players: player);
          },
        ),
      ),
    );
  }
}
