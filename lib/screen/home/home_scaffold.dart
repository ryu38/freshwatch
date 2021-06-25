import 'package:flutter/material.dart';

class HomeScaff extends StatelessWidget {
  HomeScaff({
    required this.content,
    Key? key 
  }) : 
    super(key: key);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 20, horizontal: 10
          ),
          width: double.infinity,
          child: content,
        ),
      ),
    );
  }
}