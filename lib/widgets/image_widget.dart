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
  double sigmaX = 0.0;
  double sigmaY = 0.0;

  void updateBlur(double sigmaX, double sigmaY) {
    setState(() {
      sigmaX = sigmaX;
      sigmaY = sigmaY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Text(widget.name),
      //Text(widget.pokedexNo.toString()),
      Stack(children: [
        Image.asset('../assets/witp.jpg'),
        Positioned(top: 0, left: 20, child: imgContainer())
      ])
    ]);
  }

  ImageFiltered imgContainer() {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
      child: Image.network(
        widget.sprite,
        fit: BoxFit.fill,
        width: 300,
      ),
    );
  }
}
