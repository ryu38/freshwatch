import 'package:flutter/material.dart';
import 'package:freshwatch/features/local.dart';
import 'package:freshwatch/screen/authenticate/sign_in.dart';
import 'package:freshwatch/theme/colors.dart';
import 'package:freshwatch/widgets/title.dart';

class InitialPage extends StatelessWidget {

  InitialPage({
    required this.refresh
  });

  final void Function() refresh;

  Future _navigateSignInPage(BuildContext context) async {
    await Navigator.of(context).pushNamed('/signin');
  }

  Future _startInLocal() async {
    await LocalData.setNotInitFlag();
    refresh();
  }

  @override
  Widget build(BuildContext context) {

    Widget button(String text, Color color, Function() pressedFunc) => SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          primary: color,
        ),
        onPressed: pressedFunc,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        )
      ),
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTitle(fontSize: 28),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  button(
                    'Sign in or make account',
                    AppColors.main,
                    () async {
                      await _navigateSignInPage(context);
                    }
                  ),
                  const SizedBox(height: 12),
                  button(
                    'Start and saving data in local',
                    Colors.grey,
                    () async {
                      await _startInLocal();
                    }
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: const Text(
                      'If you have your own account, '
                      'you can save your data to online cloud '
                      'and even if you lose this app, '
                      'you can get your data backup '
                      'when this app is reinstalled'
                      '\n\n'
                      'After starting in local, you can create account '
                      'but local data will not be used when you are logged in',
                      style: TextStyle(color: Color(0xFF808080)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}