import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freshwatch/models/post.dart';
import 'package:freshwatch/screen/home/post_form.dart';
import 'package:provider/provider.dart';

class DailyVeges extends StatelessWidget {
  const DailyVeges({
     Key? key,
     required this.date,
  }) : super(key: key);

  final String date;

  List<VegePost> _getDailyPosts(BuildContext context, String date) {
    final dailyPostsJson = Provider.of<AllVegePosts>(context, listen: false)
      .posts[date] as String?;
    if (dailyPostsJson != null) {
      final targetPosts = jsonDecode(dailyPostsJson) as List<dynamic>;
      return targetPosts.map<VegePost>((dynamic val) {
          final postJson = json.decode(val as String) as Map<String, dynamic>;
          return VegePost.fromJson(postJson);
        }).toList();
    } else {
      return <VegePost>[];
    }
  }

  @override
  Widget build(BuildContext context) {

    final targetPosts = _getDailyPosts(context, date);

    return ChangeNotifierProvider<DailyVegePosts>(
      create: (_) => DailyVegePosts(date, targetPosts),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  
  const _Content({ Key? key }) : super(key: key);

  void _showPostForm(BuildContext context) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      context: context, 
      builder: (_) {
        return ChangeNotifierProvider.value(
          value: Provider.of<DailyVegePosts>(context, listen: false),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            child: const PostForm(),
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    
    final _dailyPosts = Provider.of<DailyVegePosts>(context);

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text(
              "today's veges",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const Icon(
              Icons.settings,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
        Container(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _dailyPosts.posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = _dailyPosts.posts[index];
              return Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xffd4f3d3),
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
              );
            },
          ),
        ),
        Container(
          child: GestureDetector(
            onTap: () => _showPostForm(context),
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
      ],
    );
  }
}