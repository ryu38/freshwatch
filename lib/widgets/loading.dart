import 'package:flutter/material.dart';
import 'package:freshwatch/widgets/title.dart';

class Loading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTitle(fontSize: 32),
            // const SizedBox(height: 10),
            // const Text(
            //   'Loading ...',
            //   style: TextStyle(
            //     fontSize: 14,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}