import 'dart:io';
import 'package:flutter/material.dart';
import 'package:freshwatch/models/date.dart';
import 'package:freshwatch/models/post.dart';
import 'package:freshwatch/screen/home/form/edit_form.dart';
import 'package:freshwatch/screen/home/form/post_form.dart';
import 'package:freshwatch/theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyVeges extends StatelessWidget {
  DailyVeges(
    this.date, 
    { Key? key }
  ) :
    dateFmt = DateFormat('yyyy/MM/dd').format(date),
    super(key: key);

  final DateTime date;
  final String dateFmt;

  @override
  Widget build(BuildContext context) {

    final allPosts = Provider.of<AllVegePosts>(context, listen: false);

    return ChangeNotifierProxyProvider2<AllVegePosts, DateModel, DailyVegePosts>(
      create: (_) => DailyVegePosts(allPosts, date),
      update: (_, allVegePosts, dateModel, dailyVegePosts) {
        dailyVegePosts!.init(date);
        return dailyVegePosts;
      },
      child: _Content(date),
    );
  }
}

class _Content extends StatelessWidget {
  
  _Content(
    this.date,
    { Key? key }
  ) : 
    dateFmt = DateFormat('MM/dd E').format(date),
    super(key: key);

  final DateTime date;
  final String dateFmt;

  final imgSize = 60.0;

  void _showModalBottomSheet({
    required BuildContext context, required Widget child }) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Colors.white,
      context: context, 
      builder: (_) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider.value(
              value: Provider.of<AllVegePosts>(context, listen: false),
            ),
            ChangeNotifierProvider.value(
              value: Provider.of<DailyVegePosts>(context, listen: false),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: child,
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final dailyPosts = Provider.of<DailyVegePosts>(context);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              dateFmt,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: _Bar350g(size: 180),
              ),
            )
          ],
        ),
        const SizedBox(height: 15),
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: dailyPosts.posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = dailyPosts.posts[index];
              return Dismissible(
                key: ObjectKey(post),
                onDismissed: (direction) async {
                  await dailyPosts.deletePost(index);
                },
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _showModalBottomSheet(
                      context: context,
                      child: EditForm(index: index),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            post.imgUrl != ''
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(imgSize / 2),
                                  child: Image.file(
                                    File(post.imgUrl),
                                    width: imgSize,
                                    height: imgSize,
                                  ),
                                )
                                : Container(
                                  width: 60,
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.light,
                                  ),
                                  child: const Icon(Icons.grass),
                                ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(post.name),
                            ),
                          ],
                        ),
                        Container(
                          child: Text('${post.gram}g'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _showModalBottomSheet(
                context: context,
                child: const PostForm()
              );
            },
            child: Row(
              children: <Widget>[
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('Add new vege'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Bar350g extends StatelessWidget {
  const _Bar350g({ 
    required this.size,
    Key? key
  }) : 
    super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {

    var dailyGram = Provider.of<DailyVegePosts>(context).getTotalGram();
    dailyGram = dailyGram >= 350 ? 350 : dailyGram;
    final opacity = dailyGram == 350 ? 1.0 : .0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: size,
            height: 12,
            color: const Color(0xFFCCCCCC),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AnimatedContainer(
                width: size * (dailyGram / 350),
                color: AppColors.main,
                duration: const Duration(milliseconds: 500),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Opacity(
            opacity: opacity,
            child: const Icon(
              Icons.check,
              size: 20,
              color: AppColors.textMain,
            ),
          ),
        ),
      ],
    );
  }
}