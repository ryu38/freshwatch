import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freshwatch/screen/wrapper.dart';

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
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light().copyWith(
              scaffoldBackgroundColor: const Color(0xfffafafa)
            ),
            darkTheme: ThemeData.dark(),
            home: Wrapper(),
          );
        }

        return MaterialApp(
          home: Scaffold(
            body: Container(
              color: Colors.white,
              child: const Text('Loading ...'),
            ),
          ),
        );
      },
    );
  }
}
