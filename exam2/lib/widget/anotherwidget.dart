import 'package:exam2/inbox.dart';
import 'package:exam2/model.dart';
import 'package:flutter/material.dart';

class Anotherwidget extends StatelessWidget {
  final Player players;
  const Anotherwidget({super.key, required this.players});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: SizedBox(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsetsGeometry.all(20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return InboxWidget(players: players);
                        },
                      ),
                    );
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.person_3, color: Colors.red, size: 50),
                      Column(
                        children: [
                          if (players.name == " ")
                            Text("Unknown User")
                          else
                            Text(players.name),

                          Row(
                            children: [
                              SizedBox(height: 20, width: 20),
                              Icon(Icons.monitor),
                              Text(players.status),
                              SizedBox(width: 10),
                              Text(players.gamePlaying),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
