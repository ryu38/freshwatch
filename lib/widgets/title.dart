import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {

  AppTitle({
    this.fontSize = 24.0
  });

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
        children: [
          const TextSpan(
            text: 'Fresh',
            style: TextStyle(
              color: Color(0xff56ad54)
            ),
          ),
          const TextSpan(
            text: 'Watch',
            style: TextStyle(
              color: Color(0xff026500)
            ),
          ),
        ]
      ),
    );
  }
}