import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_guess/widgets/pokedex.dart';
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
  bool isOver = false;
  bool showPokedex = false;
  List<String> guesses = [];
  String guess = "";
  TextEditingController guessController = TextEditingController();
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('users');

  Future<void> _addPokemon(String name) {
    User? user = FirebaseAuth.instance.currentUser;
    print("Caught!");
    return collectionRef.doc(user?.uid).collection('caught').doc(name).set({
      'name': name,
      'level': 5,
    });
  }

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
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Row(children: [
        const Expanded(child: Text("left")),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Column(
              children: [
                pokeWidge,
                Text(
                  isOver == true ? pokeWidge.getPokeName()! : "Who's that",
                  style: const TextStyle(fontFamily: 'Pokemon', fontSize: 50),
                ),
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      inputField(),
                      for (int i = 0; i < guesses.length; i++) Text(guesses[i]),
                      PokeNames(guessInput: guess),
                      if (isOver == true) resetBtn(),
                      resetBtn(), //For testing, should be removed in release
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const Spacer(),
              pokedexButton(),
              if (showPokedex) const Pokedex(),
              const Spacer(),
            ],
          ),
        )
      ]),
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
    if (guesses.length >= 5) {
      return;
    }
    if (pokeWidge.getPokeName() == val) {
      //Win
      _addPokemon(pokeWidge.getPokeName()!);
      pokeWidge.getImageBox()?.updateColor();
      pokeWidge.getImageBox()?.updateBlur(20, 20);
      isOver = true;
    } else {
      updateGuesses(val);
      pokeWidge.getImageBox()?.updateBlur(5, 5);
      if (guesses.length > 4) {
        //Loss
        isOver = true;
        pokeWidge.getImageBox()?.updateColor();
        pokeWidge.getImageBox()?.updateBlur(20, 20);
      }
    }
    guessController.text = "";
    setState(() {});
  }

  resetGame() {
    isOver = false;
    pokeWidge.randomizePoke();
    guesses = [];
    setState(() {});
  }

  ElevatedButton resetBtn() {
    return ElevatedButton(
      onPressed: resetGame,
      child: const Text(
        "Reset",
      ),
    );
  }

  ElevatedButton pokedexButton() {
    return ElevatedButton(
      onPressed: () => setState(() {
        showPokedex = !showPokedex;
      }),
      child: const Text("View caught pokemon"),
    );
  }
}
