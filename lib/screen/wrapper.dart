import 'package:flutter/material.dart';
import 'package:freshwatch/features/local.dart';
import 'package:freshwatch/screen/authenticate/authenticate.dart';
import 'package:freshwatch/service/auth.dart';
import 'package:freshwatch/widgets/loading.dart';
import 'package:provider/provider.dart';
import 'package:freshwatch/screen/home/home.dart';
import 'package:freshwatch/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Content();
  }
}

class _Content extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final userData = Provider.of<UserData?>(context);

    if (userData == null) {
      return Loading();
    } else {
      return FutureBuilder(
        future: LocalData.getNotInitFlag,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (!userData.isLogin && !snapshot.hasData) {
              print(snapshot.data);
              return Authenticate();
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