import 'package:flutter/material.dart';
import 'poke_widget.dart';
import 'name_assist.dart';

PokeState pokeState = pokeState = PokeState();
PokeWidget pokeWidge = PokeWidget(
  pokeState: pokeState,
);

class GuessGame extends StatefulWidget {
  const GuessGame({Key? key}) : super(key: key);

  @override
  GuessGameState createState() => GuessGameState();
}

class GuessGameState extends State<GuessGame> {
  List<String> guesses = [];
  String guess = "";
  TextEditingController guessController = TextEditingController();

  void updateGuesses(String guess) {
    setState(() {
      guesses.add(guess);
    });
  }

  @override
  void initState() {
    super.initState();

    guessController.addListener(_handleControllerChange);
  }

  _handleControllerChange() {
    setState(() {
      guess = guessController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        pokeWidge,
        SizedBox(
          width: 300,
          child: Column(
            children: [
              inputField(),
              for (int i = 0; i < guesses.length; i++) Text(guesses[i]),
              PokeNames(guessInput: guess),
              resetBtn(),
            ],
          ),
        ),
      ],
    );
  }

  TextField inputField() {
    return TextField(
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      controller: guessController,
      decoration: const InputDecoration(
        hintText: "Enter your guess",
      ),
      onSubmitted: (value) => onSubmit(value),
      textAlign: TextAlign.center,
    );
  }

  onSubmit(String val) async {
    if (pokeWidge.getPokeName() == val) {
      pokeWidge.getImageBox()?.updateColor();
      pokeWidge.getImageBox()?.updateBlur(20, 20);
    } else {
      updateGuesses(val);
      pokeWidge.getImageBox()?.updateBlur(5, 5);
    }
  }

  resetGame() {
    pokeWidge.randomizePoke();
  }

  ElevatedButton resetBtn() {
    return ElevatedButton(
      onPressed: resetGame,
      child: const Text("Reset"),
    );
  }
}
