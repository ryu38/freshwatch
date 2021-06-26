import 'package:flutter/material.dart';
import 'package:freshwatch/features/database.dart';
import 'package:freshwatch/models/date.dart';
import 'package:freshwatch/models/post.dart';
import 'package:freshwatch/screen/home/bar_chart.dart';
import 'package:freshwatch/screen/home/daily_veges.dart';
import 'package:freshwatch/screen/home/history.dart';
import 'package:freshwatch/screen/home/home_scaffold.dart';
import 'package:freshwatch/theme/colors.dart';
import 'package:freshwatch/widgets/card.dart';
import 'package:freshwatch/widgets/title.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AllVegePosts.init(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Text('Loading'),
          );
        } else {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AllVegePosts>.value(
                value: snapshot.data! as AllVegePosts,
              ),
              ChangeNotifierProvider<DateModel>(
                create: (_) => DateModel(),
              ),
            ],
            child: _Content(),
          );
        }
      }
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({ Key? key }) : super(key: key);

  @override
  __ContentState createState() => __ContentState();
}

class __ContentState extends State<_Content> {

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

    return HomeScaff(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 25, horizontal: 15
            ),
            child: AppTitle(),
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
            content: DailyVeges(date.today),
          ),
          DashboardCard(
            content: BarChart(),
          ),
          DashboardCard(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await Database.clearAll();
                  }, 
                  child: Text('clear database')
                ),
                Text(Provider.of<AllVegePosts>(context).posts.toString()),
              ],
            ),
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
                  Text('History'),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}