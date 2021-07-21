import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freshwatch/features/local.dart';
import 'package:freshwatch/models/user.dart';
import 'package:freshwatch/service/firestore.dart';
import 'package:freshwatch/utils/error_toast.dart';
import 'package:intl/intl.dart';

class VegePost {

  VegePost({
    required this.name,
    required this.gram,
    this.imgUrl = '',
  });

  VegePost.fromJson(Map<String, dynamic> json) :
    name = json['name'] as String,
    gram = json['gram'] as int,
    imgUrl = json['imgUrl'] as String;

  final String name;
  final int gram;
  final String imgUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'name': name,
    'gram': gram,
    'imgUrl': imgUrl,
  };
}

class AllVegePosts with ChangeNotifier {

  AllVegePosts(
    this._posts,
    this._startDate,
    this._userData,
  );

  Map<String, dynamic> _posts;
  final UserData _userData;
  final DateTime _startDate;

  Map<String, dynamic> get posts => _posts;
  int get dayLength => _posts.length;
  DateTime get startDate => _startDate;

  static Future<AllVegePosts> init(UserData userData) async {
    final Map<String, dynamic> posts;
    final DateTime startDate;
    if (userData.isLogin) {
      final fsInstance = FirestoreService(userData.uid!);
      try {
        posts = await fsInstance.getAllPosts;
        startDate = await fsInstance.getStartDate;
      } catch (e) {
        await ErrorToast.show(
          'An Internet Error has occurred. The app could not read data.'
        );
        return Future.error(e);
      }
    } else {
      try {
        posts = await LocalData.loadAllPostLocal();
        startDate = await LocalData.loadStartDate();
      } catch (e) {
        await ErrorToast.show(
          'A error occurred while reading data from local. The app could not read data.'
        );
        return Future.error(e);
      }
    }
    return AllVegePosts(posts, startDate, userData);
  }

  Future<void> update() async {
    _posts = _userData.isLogin 
        ? await FirestoreService(_userData.uid!).getAllPosts
        : await LocalData.loadAllPostLocal();
    notifyListeners();
  }
}

class DailyVegePosts with ChangeNotifier {

  DailyVegePosts(
    this._allPosts,
    this._date,
    this._userData,
  ) {
    init(_allPosts);
  }
  
  final AllVegePosts _allPosts;
  final DateTime _date;
  final UserData _userData;

  late List<VegePost> _posts;

  DateTime get date => _date;
  List<VegePost> get posts => _posts;

  void init(AllVegePosts allPosts) {
    
    final String dateFmt;
    final List<dynamic>? targetPosts;
    if (_userData.isLogin) {
      dateFmt = DateFormat('yyyy-MM-dd').format(_date);
      targetPosts = allPosts.posts[dateFmt] as List<dynamic>?;
    } else {
      dateFmt = DateFormat('yyyy/MM/dd').format(_date);
      final dailyPostsJson = allPosts.posts[dateFmt] as String?;
      targetPosts = dailyPostsJson != null 
          ? jsonDecode(dailyPostsJson) as List<dynamic> : null;
    }

    if (targetPosts != null) {
      _posts = targetPosts.map<VegePost>((dynamic val) {
        final postJson = json.decode(val as String) as Map<String, dynamic>;
        return VegePost.fromJson(postJson);
      }).toList();
    } else {
      _posts = <VegePost>[];
    }
  }

  Future<void> _reflect() async {
    bool result;
    if (_userData.isLogin) {
      try {
        await FirestoreService(_userData.uid!).updateDailyData(this);
        result = true;
      } catch (e) {
        await ErrorToast.show(
          'An internet error has occurred. The post could not be saved.'
        );
        result = false;
      }
    } else {
      result = await LocalData.addPostLocal(this);
      if (!result) {
        await ErrorToast.show(
          'A error occurred while saving data in local. The post could not be saved.'
        );
      }
    }

    if (result) {
      await _allPosts.update();
    } else {
      init(_allPosts);
    }

    notifyListeners();
  }

  Future<void> addPost(VegePost newPost) async {
    _posts.add(newPost);
    await _reflect();
  }

  Future<void> updatePost(int index, VegePost newPost) async {
    _posts[index] = newPost;
    await _reflect();
  }

  Future<void> deletePost(int index) async {
    _posts.removeAt(index);
    await _reflect();
  }

  double getTotalGram() {
    var totalGram = 0.0;
    for (final post in _posts) {
      totalGram = totalGram + post.gram;
    }
    return totalGram;
  }
}

class DailyVegePostsInSpan {

  DailyVegePostsInSpan(
    this._allPosts,
    this._userData,
    DateTime from,
    DateTime to,
  ) {
    init(from, to);
  }

  final AllVegePosts _allPosts;
  final UserData _userData;
  late List<DailyVegePosts> _posts;

  List<DailyVegePosts> get posts => _posts;

  void init(DateTime from, DateTime to) {
    final posts = <DailyVegePosts>[];
    final dateSpan = to.difference(from).inDays;
    for (var d = 0; d <= dateSpan; d++) {
      posts.add(
        DailyVegePosts(_allPosts, from.add(Duration(days: d)), _userData)
      );
    }
    _posts = posts;
  }
}