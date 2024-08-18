import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Button extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Widget? icon; // Optional icon property

  const Button({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.icon, // Initialize icon property
  }) : super(key: key);

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      width: double.infinity,
      child: GestureDetector(
        onTapDown: (_) {
          setState(() {
            _isPressed = true;
          });
        },
        onTapUp: (_) {
          setState(() {
            _isPressed = false;
          });
          widget.onPressed();
        },
        onTapCancel: () {
          setState(() {
            _isPressed = false;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 20),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _isPressed ? CupertinoColors.systemGrey5 : CupertinoColors.transparent,
            borderRadius: BorderRadius.circular(5.5),
            border: Border.all(
              color: CupertinoColors.systemGrey,
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.isLoading 
              ? const SizedBox(
                  child: Center(
                    child: CircularProgressIndicator(color: CupertinoColors.systemGrey2, strokeWidth: 2.5),
                  ),
                  width: 15,
                  height: 15,
                )
              : (widget.icon != null)
                ? Row(
                  children: [ 
                    Padding(
                      padding: const EdgeInsets.only(right: 4.0), // Add spacing between text and icon
                      child: SizedBox(
                        height: 12,
                        width: 12,
                        child: widget.icon,
                      ),
                    ), 
                    Text(
                      widget.text, 
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14, 
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    ],
                )
                : Text(
                    widget.text, 
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14, 
                      fontWeight: FontWeight.w600,
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
