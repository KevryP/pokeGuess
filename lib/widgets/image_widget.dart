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
    return Column(children: [
      Stack(children: [
        pokeBackground(),
        backgroundBlur(),
        Positioned(top: 0, left: 20, child: pokeImg())
      ])
    ]);
  }

  ImageFiltered pokeImg() {
    return ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(gradientColor, BlendMode.modulate),
          child: Image.network(
            widget.sprite,
            fit: BoxFit.fill,
            width: 300,
          ),
        ));
  }

  ClipRRect pokeBackground() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset('../assets/witp.jpg'),
    );
  }

  BackdropFilter backgroundBlur() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
      child: pokeBackground(),
    );
  }
}
