import 'package:flutter/material.dart';

class AppTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: 'Yasai',
            style: TextStyle(
              color: Color(0xff56ad54)
            ),
          ),
          TextSpan(
            text: 'Query',
            style: TextStyle(
              color: Color(0xff026500)
            ),
          ),
        ]
      ),
    );
  }
}