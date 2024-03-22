import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final Color backgroundColor;
  final String text;
  final TextStyle textStyle;
  final double width;
  final VoidCallback onPressed;

  // Constructor
  const AppTextButton({
    super.key,
    required this.backgroundColor,
    required this.text,
    required this.textStyle,
    this.width = 200.0,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          // textStyle: textStyle,
          padding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 10.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle,
        ),
      ),
    );
  }
}
