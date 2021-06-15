import 'package:flutter/material.dart';
import 'package:freshwatch/screen/home/daily_veges.dart';
import 'package:freshwatch/widgets/card.dart';
import 'package:freshwatch/widgets/title.dart';


class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              child: AppTitle(),
            ),
            const DashboardCard(
              backgroundColor: Color(0xff56ad54),
              content: Text(
                'You should eat 350g of vegetables everyday !',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const DashboardCard(
              content: DailyVeges(),
            ),
          ],
        ),
      ),
    );
  }
}