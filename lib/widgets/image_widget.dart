import 'dart:ui';
import 'package:flutter/material.dart';

class ImageBox extends StatefulWidget {
  final String sprite;
  final ImageBoxState box;

  const ImageBox({
    super.key,
    required this.sprite,
    required this.box,
  });

  @override
  ImageBoxState createState() => box;
}

class ImageBoxState extends State<ImageBox> {
  double sigmaX = 20.0;
  double sigmaY = 20.0;
  Color gradientColor = Colors.black;

  void updateBlur(double newSigmaX, double newSigmaY) {
    setState(() {
      if (newSigmaX > sigmaX) {
        sigmaX = 0;
        sigmaY = 0;
        return;
      }
      sigmaX = sigmaX - newSigmaX;
      sigmaY = sigmaY - newSigmaY;
    });
  }

  void updateColor() {
    setState(() {
      if (gradientColor == Colors.transparent) {
        gradientColor = Colors.black;
      } else {
        gradientColor = Colors.transparent;
      }
    });
  }

  void resetImage() {
    setState(() {
      gradientColor = Colors.black;
      sigmaX = 20;
      sigmaY = 20;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        backgroundBlur(),
      ]),
      child: Column(children: [
        Stack(children: [
          pokeBackground(),
          pokeImg(),
        ])
      ]),
    );
  }

  ImageFiltered pokeImg() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(gradientColor, BlendMode.modulate),
          child: Image.network(
            widget.sprite,
            fit: BoxFit.fill,
            height: screenHeight / 3.5,
            width: screenWidth / 6.5,
          ),
        ));
  }

  ClipRRect pokeBackground() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(
        '../assets/witp.jpg',
        fit: BoxFit.fill,
        height: screenHeight / 3.5,
        width: screenWidth / 3.5,
      ),
    );
  }

  BoxShadow backgroundBlur() {
    return const BoxShadow(
      color: Colors.red,
      spreadRadius: 10,
      blurRadius: 30,
    );
  }
}
