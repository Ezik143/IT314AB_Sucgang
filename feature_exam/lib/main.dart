import 'package:flutter/material.dart';
import 'widgets/profiles.dart';
import 'data/player.dart';
import 'data/player_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
      backgroundColor: Colors.black12,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: Text("Match Details", style: TextStyle(color: Colors.white)),
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black12,
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("My Team", style: TextStyle(color: Colors.white)),
                  Text("12", style: TextStyle(color: Colors.white)),
                  Icon(Icons.gps_fixed_outlined, color: Colors.white),
                  Text("14", style: TextStyle(color: Colors.white)),
                  Text("Opponent", style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Column(
              children: [SizedBox(child: Image.asset("assets/Map/ascent.jpg"))],
            ),

            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      "My Team",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Icon(Icons.bar_chart, color: Colors.white),
                  ),
                  Expanded(
                    flex: 3,
                    child: Icon(Icons.face, color: Colors.white),
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: players.length,
              itemBuilder: (context, index) {
                return ProfileCard(player: players[index]);
              },
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      "Opponents",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Icon(Icons.bar_chart, color: Colors.white),
                  ),
                  Expanded(
                    flex: 3,
                    child: Icon(Icons.face, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
