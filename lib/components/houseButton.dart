import 'package:doorbell/components/avatar.dart';
import 'package:flutter/material.dart';

class HouseButton extends StatefulWidget {
  final String imagePath;
  final VoidCallback onPressed;
  final double height;
  final List<Avatar> avatars;

  const HouseButton({
    Key? key,
    required this.imagePath,
    required this.onPressed,
    this.height = 200.0,
    required this.avatars,
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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTapDown: _onTapDown,
          onTapUp: _onTapUp,
          onTapCancel: _onTapCancel,
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              widget.imagePath,
              height: widget.height,
            ),
          ),
        ),
        Positioned(
          bottom: -40,
          child: Center(
            child: Container(
              width: 200,
              child: Wrap(
                children: widget.avatars.map((avatar) {
                  return avatar;
                }).toList(),
              ),
            ),
          ),
        )
        
      ],
    );
  }
}
