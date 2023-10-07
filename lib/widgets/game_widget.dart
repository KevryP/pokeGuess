import 'package:flutter/material.dart';
import 'poke_widget.dart';

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

  void updateGuesses(String guess) {
    setState(() {
      guesses.add(guess);
    });
  }

  @override
  Widget build(BuildContext context) {
    //const pokeWidget = PokeWidget(); // Create an instance of PokeWidget

    return Column(
      children: [
        pokeWidge,
        newMethod(),
      ],
    );
  }

  SizedBox newMethod() {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Enter your guess",
            ),
            onSubmitted: (value) => onSubmit(value),
            textAlign: TextAlign.center,
          ),
          for (int i = 0; i < guesses.length; i++) Text(guesses[i]),
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
