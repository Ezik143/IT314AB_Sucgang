import 'package:flutter/material.dart';
import '../data/player_model.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.player});

  final Player player;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: Border.all(color: Colors.white),
      color: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  CircleAvatar(backgroundImage: AssetImage(player.imagePath!)),
                  const SizedBox(width: 10, height: 10),
                  Text(
                    player.name!,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(flex: 2, child: Center(child: Text('${player.stat}'))),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(player.standing!),
                  DropdownButton(
                    items: const [],
                    onChanged: (value) {},
                    hint: const Text('details'),
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
