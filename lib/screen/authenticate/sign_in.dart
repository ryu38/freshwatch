import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freshwatch/features/local.dart';
import 'package:freshwatch/service/auth.dart';
import 'package:freshwatch/theme/colors.dart';
import 'package:freshwatch/utils/error_toast.dart';
import 'package:freshwatch/widgets/card.dart';
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: AppColors.main,
          mini: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(child: AppTitle(fontSize: 28)),
              const SizedBox(height: 32),
              DashboardCard(
                content: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: const Text(
                          'Sign in or make your account',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Divider(height: 32),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          primary: Color(0xFF666666),
                          side: const BorderSide(color: Colors.grey)
                        ),
                        onPressed: () async {
                          final result = await _auth.signInGoogle();
                          if (result == null) {
                            await ErrorToast.show(
                              'A error has occurred. Failed to sign in.'
                            );
                          } else {
                            await LocalData.setNotInitFlag();
                            Navigator.pop(context);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const <Widget>[
                              FaIcon(FontAwesomeIcons.google, color: AppColors.textMain),
                              SizedBox(width: 16),
                              Text(
                                'Sign in with Google',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}