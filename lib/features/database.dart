import 'dart:convert';

import 'package:freshwatch/models/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Database {

  static Future<String?> get printSP async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('posts');
  }

  static Future<Map<String, dynamic>> loadAllPostLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final allPostsJson = prefs.getString('posts') ?? '{}';
    return jsonDecode(allPostsJson) as Map<String, dynamic>;
  }

  static Future<bool> addPostLocal(DailyVegePosts dailyPosts) async {

    final posts = dailyPosts.posts;
    final date = dailyPosts.date;

    final jsonList = posts.map((val) {
      return json.encode(val);
    }).toList();

    final database = await loadAllPostLocal();
    database[date] = jsonEncode(jsonList);
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('posts', json.encode(database));
  }

}