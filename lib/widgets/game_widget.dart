import 'package:flutter/material.dart';
import 'poke_widget.dart';
import 'name_assist.dart';

PokeState pokeState = PokeState();
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
        inputField(),
      ],
    );
  }

  SizedBox inputField() {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          TextField(
            controller: guessController,
            decoration: const InputDecoration(
              hintText: "Enter your guess",
            ),
            onSubmitted: (value) => onSubmit(value),
            textAlign: TextAlign.center,
          ),
          for (int i = 0; i < guesses.length; i++) Text(guesses[i]),
          PokeNames(guessInput: guess),
        ],
      ),
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
}
