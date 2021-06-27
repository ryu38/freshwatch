import 'package:flutter/material.dart';

class HomeScaff extends StatelessWidget {
  HomeScaff({
    required this.content,
    this.scrollController,
    Key? key 
  }) : 
    super(key: key);

  final Widget content;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
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