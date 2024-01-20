import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  Future<int> _getNumCaught() async {
    User? user = FirebaseAuth.instance.currentUser;
    AggregateQuerySnapshot qSnapshot =
        await collectionRef.doc(user?.uid).collection('caught').count().get();

    return qSnapshot.count;
  }

  Widget pokedexWidget(screenWidth) {
    return FutureBuilder(
      future: _getNumCaught(),
      builder: (context, snapshot) {
        if (snapshot.hasData == false) {
          return const Text("Loading...");
        }
        return Container(
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
                  "Pokemon Caught: ${snapshot.data!}",
                  style: const TextStyle(fontFamily: 'PokemonGb'),
                ),
              ]),
            ));
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: cardTextContainer(
                                screenWidth,
                                screenHeight,
                                "Email Address: ",
                                (widget.user == null
                                    ? ""
                                    : widget.user!.email!)),
                          ),
                        ),
                        Expanded(child: pokedexWidget(screenWidth)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: cardTextContainer(
                                screenWidth,
                                screenHeight,
                                "Current Streak: ",
                                (widget.user == null
                                    ? ""
                                    : widget.user!.email!)),
                          ),
                        ),
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

  Container cardTextContainer(
      double screenWidth, double screenHeight, String label, String userInfo) {
    return Container(
        alignment: Alignment.centerLeft,
        width: screenWidth / 6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.blue.shade100,
        ),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Row(children: [
            Text(
              label,
              style: const TextStyle(fontFamily: 'PokemonGb'),
            ),
            Text(
              userInfo ?? "",
              style: const TextStyle(fontFamily: 'PokemonGb'),
            )
          ]),
        ));
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
      child: SvgPicture.asset('PokeballGrey.svg'),
    );
  }
}
