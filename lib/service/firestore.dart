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
    final ref = collection.doc(uid).collection('vege_data');
    final allData = await ref.get();
    final allPostsMap = <String, List<dynamic>>{};
    for (final docDaily in allData.docs) {
      final dailyData = await ref.doc(docDaily.id).get();
      final dailyPosts = dailyData.data()?['posts'] as List<dynamic>?;
      if (dailyPosts != null) {
        allPostsMap[docDaily.id] = dailyPosts;
      }
    }
    return allPostsMap;
  }

  Future<DateTime> get getStartDate async {
    final allData = await getAllData;
    final startDateFmt = allData?['start_date'] as String?;
    if (startDateFmt == null) {
      return LocalData.loadStartDate();
    }
    return DateFormat('yyyy-MM-dd').parse(startDateFmt);
  }

  Future<void> updateDailyData(DailyVegePosts dailyVegePosts) async {
    if (await getAllData == null) {
      final startDate = await LocalData.loadStartDate();
      final startDateFmt = DateFormat('yyyy-MM-dd').format(startDate);
      await collection.doc(uid).set(<String, dynamic>{
        'start_date': startDateFmt,
      });
    }
    final jsonPosts = dailyVegePosts.posts
        .map((post) => json.encode(post)).toList();
    final dateFmt = DateFormat('yyyy-MM-dd').format(dailyVegePosts.date);
    await collection.doc(uid)
        .collection('vege_data').doc(dateFmt).set(<String, List<String>>{
          'posts': jsonPosts
        });
  }
}