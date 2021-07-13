import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freshwatch/features/local.dart';
import 'package:freshwatch/models/post.dart';
import 'package:intl/intl.dart';

class FirestoreService {

  FirestoreService(this.uid);

  final String uid;

  final collection = FirebaseFirestore.instance.collection('veges');

  Future<Map<String, dynamic>?> get getAllData async {
    final result = await collection.doc(uid).get();
    return result.data();
  }

  Future<Map<String, dynamic>> get getAllPosts async {
    final allData = await getAllData;
    return allData?['vege_data'] as Map<String, dynamic>? 
        ?? <String, dynamic>{};
  }

  Future<DateTime> get getStartDate async {
    final allData = await getAllData;
    final startDateFmt = allData?['start_date'] as String?;
    if (startDateFmt == null) {
      return LocalData.loadStartDate();
    }
    return DateFormat('yyyy-MM-dd').parse(startDateFmt);
  }

  Future<List<dynamic>?> getDailyData(DateTime date) async {
    final dateFmt = DateFormat('yyyy-MM-dd').format(date);
    final allData = await getAllData;
    return allData?['vege_data'][dateFmt] as List<dynamic>?;
  }

  Future updateDailyData(DailyVegePosts dailyVegePosts) async {
    if (await getAllData == null) {
      final startDate = await LocalData.loadStartDate();
      final startDateFmt = DateFormat('yyyy-MM-dd').format(startDate);
      await collection.doc(uid).set(<String, dynamic>{
        'start_date': startDateFmt,
        'vege_data': <String, List<String>>{}
      });
    }
    final jsonPosts = dailyVegePosts.posts
        .map((post) => json.encode(post)).toList();
    final dateFmt = DateFormat('yyyy-MM-dd').format(dailyVegePosts.date);
    await collection.doc(uid).update({
      'vege_data.$dateFmt': jsonPosts
    });
  }
}