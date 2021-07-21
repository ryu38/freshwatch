import 'dart:convert';

import 'package:freshwatch/models/post.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class LocalData {

  static Future<bool?> get getNotInitFlag async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('not_init');
  }

  static Future<bool> setNotInitFlag() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setBool('not_init', true);
  }

  static Future<bool> resetInitFlag() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('not_init');
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  static Future<Map<String, dynamic>> loadAllPostLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final allPostsJson = prefs.getString('posts') ?? '{}';
    return jsonDecode(allPostsJson) as Map<String, dynamic>;
  }

  static Future<DateTime> loadStartDate() async {
    final prefs = await SharedPreferences.getInstance();
    const key = 'start_date';
    var startDateStr = prefs.getString(key);
    late DateTime startDate;
    if (startDateStr == null) {
      final now = DateTime.now();
      startDate = DateTime(now.year, now.month, now.day);
      startDateStr = DateFormat('yyyy/MM/dd').format(startDate);
      await prefs.setString(key, startDateStr);
    } else {
      startDate = DateFormat('yyyy/MM/dd').parse(startDateStr);
    }
    return startDate;
  }

  static Future<bool> addPostLocal(DailyVegePosts dailyPosts) async {

    final posts = dailyPosts.posts;
    final date = DateFormat('yyyy/MM/dd').format(dailyPosts.date);

    final database = await loadAllPostLocal();
    if (posts.isNotEmpty) {
      final jsonList = posts.map((val) {
        return json.encode(val);
      }).toList();
      database[date] = jsonEncode(jsonList);
    } else {
      database.remove(date);
    }
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('posts', json.encode(database));
  }

}

class LocalStorage {

  static Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}