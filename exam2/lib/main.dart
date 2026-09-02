import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  int onlineNum = 4;

  String p1 = "MissYouLikeKrazy";
  String p2 = "bread";
  String p3 = "the14th";

  String p4 = "Carlendish";
  String p5 = "D1yah";

  String playing = "playing";
  String online = "Online";
  String away = "Away";
  String valorant = "valorant";
  String riotMobile = "Riot Mobile";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        // backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.white, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: Stream.empty,
                        child: Text(
                          "Friends",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      TextButton(
                        onPressed: Stream.empty,
                        child: Text(
                          "Messages",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),

                      TextButton(
                        onPressed: Stream.empty,
                        child: Text(
                          "Request",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: SearchBar(
                      leading: Icon(Icons.search),
                      hintText: "Search",
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.import_contacts, color: Colors.white),
                      SizedBox(height: 20, width: 20),
                      Text(valorant, style: TextStyle(color: Colors.white)),
                      SizedBox(height: 20, width: 20),
                      Text("3", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),

                SizedBox(
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.person_3, color: Colors.red, size: 50),

                              Column(
                                children: [
                                  Text(p1),

                                  Row(
                                    children: [
                                      SizedBox(height: 20, width: 20),
                                      Icon(Icons.monitor),
                                      Text(online),
                                      SizedBox(width: 10),
                                      Text(valorant),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.person_3, color: Colors.red, size: 50),

                              Column(
                                children: [
                                  Text(p2),

                                  Row(
                                    children: [
                                      SizedBox(height: 20, width: 20),
                                      Icon(Icons.monitor),
                                      Text(playing),
                                      SizedBox(width: 10),
                                      Text(valorant),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.person_3, color: Colors.red, size: 50),

                              Column(
                                children: [
                                  Text(p3),

                                  Row(
                                    children: [
                                      SizedBox(height: 20, width: 20),
                                      Icon(Icons.monitor),
                                      Text(playing),
                                      SizedBox(width: 10),
                                      Text(valorant),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: Row(children: [Text("$online  $onlineNum")]),
                ),

                SizedBox(
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.person_3, color: Colors.red, size: 50),

                              Column(
                                children: [
                                  Text(p4),

                                  Row(
                                    children: [
                                      SizedBox(height: 20, width: 20),
                                      Icon(Icons.mobile_friendly),
                                      Text(away),
                                      SizedBox(width: 10),
                                      Text(riotMobile),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: EdgeInsetsGeometry.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.person_3, color: Colors.red, size: 50),

                              Column(
                                children: [
                                  Text(p5),

                                  Row(
                                    children: [
                                      SizedBox(height: 20, width: 20),
                                      Icon(Icons.mobile_friendly),
                                      Text(away),
                                      SizedBox(width: 10),
                                      Text(riotMobile),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
