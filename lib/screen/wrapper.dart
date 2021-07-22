import 'package:flutter/material.dart';
import 'package:freshwatch/features/local.dart';
import 'package:freshwatch/screen/authenticate/init_page.dart';
import 'package:freshwatch/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:freshwatch/screen/home/home.dart';
import 'package:freshwatch/models/user.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final userData = Provider.of<UserData?>(context);

    if (userData == null) {
      return Loading();
    } else {
      return FutureBuilder<bool?>(
        future: LocalData.getNotInitFlag,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!userData.isLogin && !snapshot.hasData) {
              return InitialPage(refresh: _refresh);
            } else {
              return const Home();
            }
          } else {
            return Loading();
          }
        }
      );
    }
  }
}