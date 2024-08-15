import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final Color color;
  final String imagePath;
  final double size;

  const Avatar({
    Key? key,
    required this.color,
    required this.imagePath,
    this.size = 100.0, // Default size of the avatar
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // The colored circle at the back
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: size * 0.62,
                height: size * 0.62,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          // The semi-transparent image in front
          Center(
            child: Container(
              child: Image.asset(imagePath),
              ),
            ),
        ],
      ),
    );
  }
}
