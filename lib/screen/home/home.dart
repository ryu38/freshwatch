import 'package:flutter/material.dart';
import 'package:freshwatch/models/cache.dart';
import 'package:freshwatch/models/date.dart';
import 'package:freshwatch/models/post.dart';
import 'package:freshwatch/models/user.dart';
import 'package:freshwatch/screen/home/bar_chart.dart';
import 'package:freshwatch/screen/home/daily_veges.dart';
import 'package:freshwatch/screen/home/history.dart';
import 'package:freshwatch/screen/home/home_scaffold.dart';
import 'package:freshwatch/screen/home/retry.dart';
import 'package:freshwatch/service/auth.dart';
import 'package:freshwatch/theme/colors.dart';
import 'package:freshwatch/utils/error_toast.dart';
import 'package:freshwatch/widgets/card.dart';
import 'package:freshwatch/widgets/loading.dart';
import 'package:freshwatch/widgets/title.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    final userData = Provider.of<UserData?>(context) ?? UserData();

    return FutureBuilder<AllVegePosts>(
      future: AllVegePosts.init(userData),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Retry(refresh: _refresh);
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data != null) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<AllVegePosts>.value(
                  value: snapshot.data!,
                ),
                ChangeNotifierProvider<DateModel>(
                  create: (_) => DateModel(),
                ),
                Provider(create: (_) => Cache()),
              ],
              child: _Content(),
            );
          }
        }
        return Loading();
      }
    );
  }
}

class _Content extends StatelessWidget {

  final _auth = AuthService();

  Future _navigateSignInPage(BuildContext context) async {
    await Navigator.of(context).pushNamed('/signin');
  }

  void _navigateHistoryPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(
                value: Provider.of<AllVegePosts>(context, listen: false),
              ),
              ChangeNotifierProvider.value(
                value: Provider.of<DateModel>(context, listen: false),
              ),
              Provider.value(
                value: Provider.of<Cache>(context, listen: false),
              ),
            ],
            child: History(),
          );
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    final date = Provider.of<DateModel>(context);
    final userData = Provider.of<UserData?>(context) ?? UserData();

    Widget userAction() {
      final icon = Icon(
        Icons.person,
        color: userData.isLogin ? AppColors.textMain : const Color(0xFF666666),
        size: 25,
      );

      const msgStyle = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
      );

      const signIn = 'sign_in';
      const signOut = 'sign_out';

      final popupMenuList = userData.isLogin
          ? <PopupMenuEntry<String>>[
            PopupMenuItem(
              enabled: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'email',
                    style: msgStyle
                  ),
                  const SizedBox(height: 3),
                  Text(
                    userData.email!,
                    style: msgStyle
                  ),
                ],
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: signOut,
              child: Center(
                child: Text(
                  'sign out',
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ]
          : <PopupMenuEntry<String>>[
            const PopupMenuItem(
              enabled: false,
              child: Text(
                'You are currently not logged in',
                style: msgStyle
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(
              value: signIn,
              child: Center(
                child: Text(
                  'sign in',
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ];

      return PopupMenuButton<String>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onSelected: (String commandVal) async {
          switch (commandVal) {
            case signIn:
              await _navigateSignInPage(context);
              break;
            case signOut:
              final result = await _auth.signOut();
              if (!result) {
                await ErrorToast.show(
                  'An Internet Error has Occurred. Could not sign out'
                );
              }
              break;
            default:
              break;
          }
        },
        itemBuilder: (BuildContext context) => popupMenuList,
        child: icon,
      );
    } 

    return HomeScaff(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: AppTitle(),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff000000).withOpacity(.05),
                        blurRadius: 30,
                      )
                    ]
                  ),
                  child: userAction(),
                )
              ],
            ),
          ),
          const DashboardCard(
            backgroundColor: AppColors.main,
            content: Text(
              'You should eat 350g of vegetables everyday !',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          DashboardCard(
            content: DailyVeges(
              date: date.today,
              useProxyProv: true,
            ),
          ),
          const DashboardCard(
            content: BarChart(),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _navigateHistoryPage(context);
            },
            child: DashboardCard(
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.history,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'History',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColors.textMain,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}