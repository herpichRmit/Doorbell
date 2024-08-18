import 'package:flutter/material.dart';

class Doorbell extends StatefulWidget {
  final String imageUrl; // URL for the default image
  final String pressedImageUrl; // URL for the pressed image
  final VoidCallback onPressed; // Callback function when the button is pressed

  Doorbell({
    Key? key,
    required this.imageUrl,
    required this.pressedImageUrl,
    required this.onPressed,
  }) : super(key: key);

  @override
  _DoorbellState createState() => _DoorbellState();
}

class _DoorbellState extends State<Doorbell> {
  bool _isPressed = false; // State to track if the button is being pressed

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onPressed(); // Call the onPressed callback
      },
      onTapDown: (_) {
        setState(() {
          _isPressed = true; // Change state to pressed
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false; // Change state to not pressed
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false; // Handle tap cancel
        });
      },
      child: Image.asset(
        _isPressed ? widget.pressedImageUrl : widget.imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
