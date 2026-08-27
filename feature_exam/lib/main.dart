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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: Text("Match Details"),
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.black38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("My Team"),
                  Text("12"),
                  Icon(Icons.gps_fixed_outlined),
                  Text("Opponent"),
                ],
              ),
            ),
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.asset("assets/Map/ascent.jpg", fit: BoxFit.fill),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("My Team", style: TextStyle(color: Colors.white)),
                        Icon(Icons.bar_chart, color: Colors.white),
                        Icon(Icons.face, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.zero,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            "assets/Agents/brimstone.webp",
                          ),
                        ),
                        Text("Brmstone", style: TextStyle(color: Colors.white)),
                        Text("261", style: TextStyle(color: Colors.white)),
                        Text("23/21/6", style: TextStyle(color: Colors.white)),
                        DropdownButton(
                          items: List.empty(),
                          onChanged: (value) {},
                          hint: Text(
                            "Details",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
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
