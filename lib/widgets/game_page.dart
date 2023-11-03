import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_guess/login.dart';
import 'package:poke_guess/widgets/game_widget.dart';
import 'package:searchfield/searchfield.dart';

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
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
                onPressed: () => _signOut(), child: const Text("Sign Out")),
          ),
          const GuessGame(),
          const Spacer(),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }
}
