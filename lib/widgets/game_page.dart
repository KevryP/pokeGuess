import 'package:flutter/material.dart';
import 'package:poke_guess/widgets/game_widget.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Row(
        children: [Spacer(), GuessGame(), Spacer()],
      ),
    );
  }
}
