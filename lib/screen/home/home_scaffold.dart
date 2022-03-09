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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.white.withOpacity(0),
          elevation: 0,
        ),
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Container(
          padding: const EdgeInsets.only(
            bottom: 20, left: 10, right: 10,
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