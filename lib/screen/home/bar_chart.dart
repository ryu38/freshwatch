import 'package:flutter/material.dart';
import 'package:freshwatch/models/date.dart';
import 'package:freshwatch/models/post.dart';
import 'package:freshwatch/theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BarChart extends StatelessWidget {
  const BarChart({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final allPosts = Provider.of<AllVegePosts>(context, listen: false);
    final today = Provider.of<DateModel>(context, listen: false).today;
    final from = today.add(const Duration(days: 6) * -1);

    return ProxyProvider2<AllVegePosts, DateModel, DailyVegePostsInSpan>(
      create: (_) => DailyVegePostsInSpan(allPosts, from, today),
      update: (_, _allPosts, dateModel, dailyVegePostsInSpan) {
        return dailyVegePostsInSpan!..init(from, dateModel.today);
      },
      child: _Content()
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final posts = Provider.of<DailyVegePostsInSpan>(context, listen: false).posts;
    const size = 200.0;
    const maxGram = 500.0;

    Row dailyGramBars() {
      final bars = <Widget>[];
      for (final post in posts) {
        var gram = post.getTotalGram();
        gram = gram >= maxGram ? maxGram : gram;
        final bar = SizedBox(
          height: size,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AnimatedContainer(
                width: 14,
                height: size * (gram / maxGram),
                color: AppColors.main,
                duration: const Duration(milliseconds: 500),
              ),
            ),
          ),
        );

        final Widget label;
        if (post.date != Provider.of<DateModel>(context).today) {
          final date = DateFormat('E').format(post.date);
          label = Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.all(4),
            child: Center(
              child: Text(
                date,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14),
              ),
            )
          );
        } else {
          const date = 'today';
          label = Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.main,
            ),
            child: Center(
              child: Text(
                date,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white
                ),
              ),
            )
          );
        }

        bars.add(
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [bar, const SizedBox(height: 8), label,],
            ),
          )
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: bars,
      );
    }

    Widget scale() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        height: size,
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, (350 / maxGram) * -2 + 1),
              child: Container(
                width: double.infinity,
                height: 1,
                color: AppColors.main,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: <Widget>[
        Stack(
          children: [
            dailyGramBars(),
            scale(),
          ],
        ),
      ],
    );
  }
}