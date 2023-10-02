import 'dart:ui';

import 'package:flutter/material.dart';

class ImageBox extends StatefulWidget {
  final String name;
  final String sprite;
  final int pokedexNo;

  const ImageBox(
      {super.key,
      required this.name,
      required this.sprite,
      required this.pokedexNo});

  @override
  ImageBoxState createState() => ImageBoxState();
}

class ImageBoxState extends State<ImageBox> {
  double sigmaX = 5.0;
  double sigmaY = 1.0;

  void updateBlur(double sigmaX, double sigmaY) {
    setState(() {
      sigmaX = sigmaX;
      sigmaY = sigmaY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.name),
        Text(widget.pokedexNo.toString()),
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
          child: Image.network(widget.sprite),
        ),
      ],
    );
  }
}
