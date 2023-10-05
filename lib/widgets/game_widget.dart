import 'package:flutter/material.dart';

class GuessGame extends StatefulWidget {
  const GuessGame({super.key});

  @override
  GuessGameState createState() => GuessGameState();
}

class GuessGameState extends State<GuessGame> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 300,
      child: Column(
        children: [
          Text("Enter Your Guess:"),
          TextField(
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
