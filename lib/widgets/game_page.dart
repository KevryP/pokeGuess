import 'package:flutter/material.dart';
import 'package:poke_guess/widgets/game_widget.dart';
import 'package:poke_guess/widgets/userdetails.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: const Stack(children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Column(children: [
              Spacer(),
              Card(child: UserDetails()),
              Spacer()
            ])),
            GuessGame(),
            Spacer(),
          ],
        ),
      ]),
    );
  }
}
