import 'package:flutter/material.dart';
import 'package:freshwatch/theme/colors.dart';
import 'package:freshwatch/widgets/title.dart';

class Retry extends StatelessWidget {

  Retry({
    required this.refresh
  });

  final void Function() refresh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTitle(),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                primary: AppColors.main,
              ),
              onPressed: () {
                refresh();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'retry login',
                  style: const TextStyle(fontSize: 16),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}