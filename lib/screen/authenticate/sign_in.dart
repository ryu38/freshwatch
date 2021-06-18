import 'package:flutter/material.dart';
import 'package:freshwatch/features/auth.dart';
import 'package:freshwatch/widgets/title.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: AppTitle()
            ),
            ElevatedButton(
              onPressed: () async {
                final dynamic result = await _auth.signInAnon();
                if (result == null) {
                  print('error signing in');
                } else {
                  print('signed in');
                  print(result);
                }
              },
              child: const Text('Sign in anon'),
            )
          ],
        ),
      ),
    );
  }
}