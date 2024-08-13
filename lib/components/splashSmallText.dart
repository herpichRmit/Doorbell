import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SplashSmallText extends StatelessWidget {
  final VoidCallback onPressed;

  const SplashSmallText({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        const Text('Not what your looking for? ', style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 12.0, fontWeight: FontWeight.normal, letterSpacing: 0.0)),
        TextButton(
          onPressed: onPressed, 
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            alignment: Alignment.centerLeft
          ),
          child: const Text(
            'Back', 
            style: TextStyle(
              fontSize: 12.0, 
              fontWeight: FontWeight.w500, 
              color: CupertinoColors.systemGrey,
              letterSpacing: 0.0)),
        )
      ]
    );
  }
}
