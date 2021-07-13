import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshwatch/models/user.dart';
import 'package:freshwatch/screen/authenticate/sign_in.dart';
import 'package:freshwatch/screen/wrapper.dart';
import 'package:freshwatch/service/auth.dart';
import 'package:freshwatch/widgets/loading.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Container(
              color: Colors.white,
              child: const Text('Firebase Error'),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<UserData?>.value(
            value: AuthService().user,
            initialData: null,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.light().copyWith(
                scaffoldBackgroundColor: const Color(0xfffafafa)
              ),
              darkTheme: ThemeData.dark(),
              initialRoute: '/',
              routes: <String, WidgetBuilder>{
                '/': (BuildContext context) => Wrapper(),
                '/signin': (BuildContext context) => SignIn(),
              }
            ),
          );
        }

        return MaterialApp(
          home: Loading()
        );
      },
    );
  }
}
