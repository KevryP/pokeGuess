import 'package:flutter/material.dart';

class TrainerCard extends StatefulWidget {
  const TrainerCard({super.key});

  @override
  State<TrainerCard> createState() => _TrainerCardState();
}

class _TrainerCardState extends State<TrainerCard> {
  @override
  Widget build(BuildContext context) {
    return background();
  }

  Container background() {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).width;

    return Container(
      height: screenHeight / 6,
      color: Colors.blue.shade400,
      child: Column(
        children: [
          const Expanded(child: Text("TRAINER CARD")),
          Expanded(
              flex: 4,
              child: Row(
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        cardTextContainer(
                            screenWidth, screenHeight, "Email Address: "),
                        cardTextContainer(
                            screenWidth, screenHeight, "Pokemon Caught: "),
                        cardTextContainer(
                            screenWidth, screenHeight, "Current Streak: "),
                      ]),
                  userImageContainer(screenWidth, screenHeight)
                ],
              )),
          const Expanded(child: Text("Achievements Placeholder"))
        ],
      ),
    );
  }

  Container cardTextContainer(
      double screenWidth, double screenHeight, String label) {
    return Container(
        margin: const EdgeInsets.all(10),
        height: screenHeight / 40,
        alignment: Alignment.centerLeft,
        width: screenWidth / 6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.blue.shade100,
        ),
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(label),
        ));
  }

  Container userImageContainer(double screenWidth, double screenHeight) {
    return Container(
      margin: const EdgeInsets.only(left: 30),
      width: screenWidth / 9,
      height: screenHeight,
      color: Colors.blue.shade100,
    );
  }
}
