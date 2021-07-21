import 'package:flutter/material.dart';

class HomeScaff extends StatelessWidget {
  HomeScaff({
    required this.content,
    this.scrollController,
    this.floatingActionButton,
    this.floatingActionButtonLocation
  });

  final Widget content;
  final ScrollController? scrollController;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

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
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}