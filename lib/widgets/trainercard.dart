import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:poke_guess/FirebaseDatabaseService.dart';
import 'package:provider/provider.dart';

class TrainerCard extends StatefulWidget {
  final User? user;
  const TrainerCard({super.key, required this.user});

  @override
  State<TrainerCard> createState() => _TrainerCardState();
}

class _TrainerCardState extends State<TrainerCard> {
  CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return background();
  }

  Widget pokeStatsWidget(screenWidth) {
    return Consumer<FirebaseDatabaseService>(
      builder: (context, value, child) {
        return FutureBuilder(
          future: value.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData == false) {
              return const Text("Loading...");
            }
            return Column(
              children: [
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      width: screenWidth / 6,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.blue.shade100,
                      ),
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Row(children: [
                          Text(
                            "Email: ${snapshot.data!['email']}",
                            style: const TextStyle(fontFamily: 'PokemonGb'),
                          ),
                        ]),
                      )),
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      width: screenWidth / 6,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.blue.shade100,
                      ),
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Row(children: [
                          Text(
                            "Total Caught: ${snapshot.data!['catches']}",
                            style: const TextStyle(fontFamily: 'PokemonGb'),
                          ),
                        ]),
                      )),
                ),
                Expanded(
                  child: Container(
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      width: screenWidth / 6,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        color: Colors.blue.shade100,
                      ),
                      child: FittedBox(
                        fit: BoxFit.fitHeight,
                        child: Row(children: [
                          Text(
                            "Longest Streak: ${snapshot.data!['longestStreak']}",
                            style: const TextStyle(fontFamily: 'PokemonGb'),
                          ),
                        ]),
                      )),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Container background() {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).width;

    return Container(
      height: screenHeight / 6,
      color: Colors.blue.shade400,
      child: Column(
        children: [
          Expanded(child: cardLabelContainer(screenWidth, screenHeight)),
          Expanded(
              flex: 4,
              child: Row(
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.user != null)
                          Expanded(child: pokeStatsWidget(screenWidth)),
                      ]),
                  userImageContainer(screenWidth, screenHeight)
                ],
              )),
          Expanded(
              child: Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            color: Colors.blue.shade700,
          )),
        ],
      ),
    );
  }

  Container cardLabelContainer(double screenWidth, double screenHeight) {
    return Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        width: screenWidth / 4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.blue.shade800,
        ),
        child: const FittedBox(
          fit: BoxFit.fitHeight,
          child: Row(children: [
            Text(
              "TRAINER CARD",
              style: TextStyle(fontFamily: 'PokemonGb'),
            ),
          ]),
        ));
  }

  Container userImageContainer(double screenWidth, double screenHeight) {
    return Container(
      margin: const EdgeInsets.only(left: 30),
      width: screenWidth / 9,
      height: screenHeight,
      //color: Colors.blue.shade100,
      child: SvgPicture.asset('assets/PokeballGrey.svg'),
    );
  }
}
