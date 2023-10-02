import 'package:flutter/material.dart';
import 'package:poke_guess/widgets/poke_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: PokeWidget(),
        ),
      ),
    );
  }
}