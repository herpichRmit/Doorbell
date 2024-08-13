import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SplashSmallText extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool backOption;
  final bool isError;

  const SplashSmallText({
    Key? key,
    this.onPressed = null,
    this.text = 'Not what your looking for?',
    this.backOption = true,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Text(text + ' ', style: TextStyle(
          color: isError ? CupertinoColors.destructiveRed :  CupertinoColors.systemGrey, 
          fontSize: 12.0, 
          fontWeight: FontWeight.normal, 
          letterSpacing: 0.0)),
        getWidget()
      ]
    );
  }

  Widget getWidget() {
    if (backOption) {
      return TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: Alignment.centerLeft
        ),
        child: Text(
          'Back', 
          style: TextStyle(
            fontSize: 12.0, 
            fontWeight: FontWeight.w500, 
            color: CupertinoColors.systemGrey,
            letterSpacing: 0.0)),
      );
    } else {
      return SizedBox();
    }
  }

}
