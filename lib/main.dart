import 'package:flutter/material.dart';
import 'package:poke_guess/widgets/game_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black45,
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: GuessGame(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
