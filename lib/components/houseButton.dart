import 'package:flutter/material.dart';

class HouseButton extends StatefulWidget {
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
  _HouseButtonState createState() => _HouseButtonState();
}

class _HouseButtonState extends State<HouseButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100), // The duration of the scaling animation
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _animation,
        child: Image.asset(
          widget.imagePath,
          width: widget.width,
          height: widget.height,
        ),
      ),
    );
  }
}
