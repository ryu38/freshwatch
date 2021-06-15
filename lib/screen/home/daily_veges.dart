import 'package:flutter/material.dart';

class DailyVeges extends StatefulWidget {
  const DailyVeges({ Key? key }) : super(key: key);

  @override
  _DailyVegesState createState() => _DailyVegesState();
}

class _DailyVegesState extends State<DailyVeges> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const Text(
              "today's veges",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Icon(Icons.settings),
          ],
        ),
      ],
    );
  }
}