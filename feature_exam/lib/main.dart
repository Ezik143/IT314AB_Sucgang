import 'dart:math';

import 'package:flutter/material.dart';

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
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(126, 0, 0, 0)),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  String p1 = "brimstone";
  String p2 = "Chamber";
  String p3 = "Clove";
  String p4 = "Cyper";
  String p5 = "Phoenix";
  String p6 = "Raze";
  String p7 = "Reyna";
  String p8 = "Sova";

  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
              // color: Colors.black12,
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

            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: Text("My Team", style: TextStyle(color: Colors.white)),
                ),
                Expanded(
                  flex: 2,
                  child: Icon(Icons.bar_chart, color: Colors.white),
                ),
                Expanded(flex: 3, child: Icon(Icons.face, color: Colors.white)),
              ],
            ),

            Card(
              shape: Border.all(color: Colors.white),
              color: Colors.black,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              "assets/Agents/brimstone.webp",
                            ),
                          ),
                          SizedBox(width: 10, height: 10),
                          Text(
                            "brimstone",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),

                    Expanded(flex: 2, child: Center(child: Text("261"))),

                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          Text("23/21/6"),
                          DropdownButton(
                            items: List.empty(),
                            onChanged: (value) {},
                            hint: Text("details"),
                          ),
                        ],
                      ),
                    ),
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
