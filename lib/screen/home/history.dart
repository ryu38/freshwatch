import 'package:flutter/material.dart';
import 'package:freshwatch/models/date.dart';
import 'package:freshwatch/models/post.dart';
import 'package:freshwatch/screen/home/daily_veges.dart';
import 'package:freshwatch/screen/home/home_scaffold.dart';
import 'package:freshwatch/widgets/card.dart';
import 'package:provider/provider.dart';

class History extends StatelessWidget {
  const History({ Key? key }) : super(key: key);

  int _calcDaysFromStart(BuildContext context) {
    final today = Provider.of<DateModel>(context).today;
    final from = Provider.of<AllVegePosts>(context).startDate;
    return today.difference(from).inDays;
  }

  DateTime _calcDateDiff(BuildContext context, int diffDays) {
    final today = Provider.of<DateModel>(context).today;
    return today.add(Duration(days: diffDays) * -1);
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaff(
      content: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 25,
            ),
            child: Text(
              'History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _calcDaysFromStart(context) + 1,
              itemBuilder: (BuildContext context, int index) {
                final date = _calcDateDiff(context, index);
                return DashboardCard(
                  content: DailyVeges(date),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}