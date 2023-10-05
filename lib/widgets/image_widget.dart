import 'dart:ui';
import 'package:flutter/material.dart';

class ImageBox extends StatefulWidget {
  final String sprite;

  const ImageBox({
    super.key,
    required this.sprite,
  });

  @override
  ImageBoxState createState() => ImageBoxState();
}

class ImageBoxState extends State<ImageBox> {
  double sigmaX = 20.0;
  double sigmaY = 20.0;
  Color gradientColor = Colors.black;

  void updateBlur(double sigmaX, double sigmaY) {
    setState(() {
      sigmaX = sigmaX;
      sigmaY = sigmaY;
    });
  }

  void updateColor() {
    setState(() {
      if (gradientColor == Colors.black) {
        gradientColor == Colors.transparent;
      } else {
        gradientColor = Colors.black;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Stack(children: [
        Image.asset('../assets/witp.jpg'),
        Positioned(top: 0, left: 20, child: imgContainer())
      ])
    ]);
  }

  ImageFiltered imgContainer() {
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
}
