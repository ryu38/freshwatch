import 'dart:io';
import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:freshwatch/models/cache.dart';
import 'package:freshwatch/models/date.dart';
import 'package:freshwatch/models/post.dart';
import 'package:freshwatch/models/user.dart';
import 'package:freshwatch/screen/home/form/edit_form.dart';
import 'package:freshwatch/screen/home/form/post_form.dart';
import 'package:freshwatch/service/storage.dart';
import 'package:freshwatch/theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyVeges extends StatelessWidget {

  DailyVeges({
    required this.date,
    this.useProxyProv = false,
  });

  final DateTime date;
  final bool useProxyProv;

  @override
  Widget build(BuildContext context) {

    final userData = Provider.of<UserData?>(context) ?? UserData();

    if (useProxyProv) {
      final allPosts = Provider.of<AllVegePosts>(context);
      return ChangeNotifierProxyProvider<AllVegePosts, DailyVegePosts>(
      create: (_) => DailyVegePosts(allPosts, date, userData),
      update: (context, allPosts, dailyPosts) => dailyPosts!..init(allPosts),
      child: _Content(date),
    );
    } else {
      final allPosts = Provider.of<AllVegePosts>(context, listen: false);
      return ChangeNotifierProvider(
        create: (_) => DailyVegePosts(allPosts, date, userData),
        child: _Content(date),
      );
    }
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

  final sampleList = <int>[];

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

    Future<Image Function()?> setImgWidget(String imgName) async {
      if (imgName == '') {
        return null;
      }
      final userData = Provider.of<UserData?>(context, listen: false) ?? UserData();
      if (userData.isLogin) {
        try {
          final cacheUrls = Provider.of<Cache>(context, listen: false).imgUrls;
          cacheUrls[imgName] ??= AsyncMemoizer<String>();
          final url = await cacheUrls[imgName]!.runOnce(() => 
              StorageService(userData.uid!).getFileUrl(imgName));
          return () => Image(
              image: CachedNetworkImageProvider(url)
            );
        } catch (e) {
          return Future.error(e);
        }
      } else {
        return () => Image.file(File(imgName));
      }
    }

    Widget imgSnapshotHandler(AsyncSnapshot<Image Function()?> snapshot) {
      if (snapshot.hasError) {
        return Container(
          width: imgSize,
          height: imgSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFDDDDDD),
          ),
          child: const Icon(Icons.no_accounts),
        );
      }

      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.data == null) {
          return Container(
            width: imgSize,
            height: imgSize,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.light,
            ),
            child: const Icon(Icons.grass),
          );
        } else {
          return CircleAvatar(
            radius: imgSize / 2,
            backgroundImage: snapshot.data!().image,
            backgroundColor: Colors.transparent,
          );
        }
      }

      return Container(
        width: imgSize,
        height: imgSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xFFDDDDDD),
        ),
        child: SpinKitThreeBounce(
          color: Colors.grey,
          size: imgSize / 3
        )
      );
    }

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
        ListView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: dailyPosts.posts.length,
          itemBuilder: (BuildContext context, int index) {
            final post = dailyPosts.posts[index];
            return FutureBuilder<Image Function()?>(
              future: setImgWidget(post.imgUrl),
              builder: (context, snapshot) {
                return Dismissible(
                  key: ObjectKey(post),
                  onDismissed: (direction) async {
                    await dailyPosts.deletePost(index);
                  },
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (snapshot.connectionState == ConnectionState.done) {
                        _showModalBottomSheet(
                          context: context,
                          child: EditForm(
                            index: index,
                            currentImgWidget: snapshot.data
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                            child: Row(
                              children: [
                                imgSnapshotHandler(snapshot),
                                Flexible(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      post.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: Text('${post.gram}g'),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            );
          },
        ),
        dailyPosts.posts.length < 7
            ? Container(
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
            )
            : Container()
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