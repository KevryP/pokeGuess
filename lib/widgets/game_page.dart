import 'package:flutter/material.dart';
import 'package:poke_guess/widgets/game_widget.dart';
import 'package:poke_guess/widgets/trainercard.dart';
import 'package:poke_guess/widgets/userdetails.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: const Stack(children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                      Card(child: UserDetails()),
                    ])),
                GuessGame(),
                Expanded(child: Text("")),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
