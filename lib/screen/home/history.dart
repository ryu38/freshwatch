import 'package:flutter/material.dart';
import 'package:freshwatch/models/date.dart';
import 'package:freshwatch/models/post.dart';
import 'package:freshwatch/screen/home/daily_veges.dart';
import 'package:freshwatch/screen/home/home_scaffold.dart';
import 'package:freshwatch/theme/colors.dart';
import 'package:freshwatch/widgets/card.dart';
import 'package:provider/provider.dart';

class History extends StatefulWidget {
  const History({ Key? key }) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  late ScrollController _scrollController;
  int _loadCount = 1;
  bool _isMax = false;

  final _loadDaysPerCount = 7;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final currentPosition = _scrollController.position.pixels;
      if (maxScrollExtent > 0 &&
          (maxScrollExtent - 10.0) <= currentPosition &&
          !_isMax) {
        _addContents();
      }
    });
  }

  void _addContents() {

    setState(() {
      _loadCount++;
    });
  }

  int _loadDays(BuildContext context) {
    final today = Provider.of<DateModel>(context).today;
    final from = Provider.of<AllVegePosts>(context, listen: false).startDate;
    final maxDays = today.difference(from).inDays + 1;
    final loadDays = _loadCount * _loadDaysPerCount;
    if (loadDays > maxDays) {
      setState(() {
        _isMax = true;
      });
      return maxDays;
    }
    return loadDays;
  }

  DateTime _calcDateDiff(BuildContext context, int diffDays) {
    final today = Provider.of<DateModel>(context).today;
    return today.add(Duration(days: diffDays) * -1);
  }

  @override
  Widget build(BuildContext context) {
    return HomeScaff(
      scrollController: _scrollController,
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
          ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _loadDays(context),
            itemBuilder: (BuildContext context, int index) {
              final date = _calcDateDiff(context, index);
              return DashboardCard(
                content: DailyVeges(date: date),
              );
            },
          ),
        ],
      ),
    );
  }
}