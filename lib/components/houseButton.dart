import 'package:flutter/material.dart';

class HouseButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const HouseButton({
    Key? key,
    required this.imagePath,
    required this.onPressed,
    this.width = 210.0,
    this.height = 155.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
      ),
    );
  }
}
