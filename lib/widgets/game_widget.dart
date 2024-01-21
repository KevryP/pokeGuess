import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:poke_guess/FirebaseDatabaseService.dart';
import 'package:poke_guess/widgets/autoname.dart';
import 'package:poke_guess/widgets/userdetails.dart';
import 'poke_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

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
  bool isWin = false;
  bool showPokedex = false;
  List<String> guesses = [];
  String guess = "";
  TextEditingController guessController = TextEditingController();
  TextEditingController disabledController = TextEditingController();

  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('users');

  /*Future<bool> _addPokemon(String name) async {
    User? user = FirebaseAuth.instance.currentUser;
    print("Caught!");
    if (user != null) {
      await collectionRef.doc(user.uid).collection('caught').doc(name).set({
        'name': name,
        'level': 5,
      });
      await collectionRef.doc(user.uid).set({
        'lastCatch': DateTime.now(),
      });
      return true;
    } else {
      return true;
    }
  }*/

  void updateGuesses(String guess) {
    setState(() {
      guesses.add(guess);
    });
  }

  _handleControllerChange() {
    setState(() {
      guess = guessController.text;
    });
  }

  @override
  void initState() {
    super.initState();
    guessController.addListener(_handleControllerChange);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Row(
            children: [
              const Card(child: UserDetails()),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    label(),
                    Padding(
                        padding: const EdgeInsets.all(50), child: pokeWidge),
                    guessBox(),
                    if (isWin || (guesses.length >= 5)) resetBtn(),
                  ],
                ),
              ),
              const Expanded(child: Text(""))
            ],
          ),
        ),
      ),
    );
  }

  Stack label() {
    return Stack(
      children: [
        Text(
          (isWin || (guesses.length >= 5))
              ? pokeWidge.getPokeName()!
              : "Who's that Pokémon?",
          style: TextStyle(
              fontFamily: 'Pokemon',
              fontSize: 50,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 10
                ..color = const Color.fromARGB(255, 3, 98, 175)),
        ),
        Text(
          (isWin || (guesses.length >= 5))
              ? pokeWidge.getPokeName()!
              : "Who's that Pokémon?",
          style: TextStyle(
              fontFamily: 'Pokemon',
              fontSize: 50,
              foreground: Paint()
                ..style = PaintingStyle.fill
                ..strokeWidth = 6
                ..color = Colors.yellow),
        ),
      ],
    );
  }

  SizedBox guessBox() {
    return SizedBox(
      width: 500,
      child: Column(
        children: [
          for (int i = 0; i < guesses.length; i++)
            if (isWin && i == guesses.length - 1)
              prevGuessContainer(guesses[i], true)
            else
              prevGuessContainer(guesses[i], false),
          for (int i = guesses.length; i < 5; i++)
            if (i == guesses.length && !isWin)
              AutoName(onSubmit: onSubmit, isActive: true)
            else
              AutoName(onSubmit: onSubmit, isActive: false),
        ],
      ),
    );
  }

  Padding prevGuessContainer(guess, correct) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        height: 48,
        width: 300,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                guess.toUpperCase(),
                style: const TextStyle(color: Colors.black),
              ),
              const Spacer(),
              if (correct)
                SvgPicture.asset(
                  'Pokeball.svg',
                  height: 100,
                )
              else
                SvgPicture.asset(
                  'PokeballGrey.svg',
                  height: 100,
                ),
            ],
          ),
        ),
      ),
    );
  }

  TextField inputField(enabled) {
    return TextField(
      style: const TextStyle(color: Colors.black),
      cursorColor: Colors.black,
      enabled: enabled,
      controller: enabled ? guessController : disabledController,
      decoration: const InputDecoration(
        hintText: "Enter your guess",
      ),
      onSubmitted: (value) => onSubmit(value),
      textAlign: TextAlign.center,
    );
  }

  onSubmit(String val) async {
    var dbService =
        Provider.of<FirebaseDatabaseService>(context, listen: false);

    if (guesses.length >= 5) {
      return;
    }
    if (pokeWidge.getPokeName() == val) {
      //Win
      updateGuesses(val);
      dbService.addCaughtPoke(pokeWidge.getPokeName()!);
      pokeWidge.getImageBox()?.updateColor();
      pokeWidge.getImageBox()?.updateBlur(20, 20);
      isWin = true;
    } else {
      updateGuesses(val);
      pokeWidge.getImageBox()?.updateBlur(5, 5);
      if (guesses.length > 4) {
        //Loss
        pokeWidge.getImageBox()?.updateColor();
        pokeWidge.getImageBox()?.updateBlur(20, 20);
        dbService.updateStreak('loss');
      }
    }
    guessController.text = "";
    setState(() {/* A guess was received, progress game */});
  }

  resetGame() {
    isWin = false;
    pokeWidge.randomizePoke();
    guesses = [];
    setState(() {});
  }

  ElevatedButton resetBtn() {
    return ElevatedButton(
      onPressed: resetGame,
      child: const Text(
        "Play Again",
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
