import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool isPassword;
  final bool isError;
  final bool isMultiLine;

  const CustomTextField({
    Key? key,
    required this.controller,
    this.placeholder = 'Enter your text...',
    this.isPassword = false,
    this.isError = false,
    this.isMultiLine = false,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: SizedBox(
        height: widget.isMultiLine ? 144 : 36,
        width: double.infinity,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: CupertinoColors.transparent,
                borderRadius: BorderRadius.circular(5.5),
                border: Border.all(
                  color: widget.isError 
                      ? CupertinoColors.destructiveRed.withOpacity(0.5) 
                      : _isFocused 
                        ? CupertinoColors.systemBlue.withOpacity(0.5) 
                        : CupertinoColors.transparent,
                  width: 4,
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoColors.transparent,
                  borderRadius: BorderRadius.circular(5.5),
                  border: Border.all(
                    color: CupertinoColors.systemGrey,
                    width: 0.5,
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Center(
                  child: TextField(
                    controller: widget.controller,
                    obscureText: widget.isPassword,
                    maxLines: widget.isMultiLine ? 6 : 1,
                    decoration: InputDecoration(
                      hintText: widget.placeholder,
                      hintStyle: TextStyle(
                        color: CupertinoColors.systemGrey,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
