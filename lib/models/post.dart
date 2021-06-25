import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freshwatch/features/database.dart';
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
    this._startDate
  );

  Map<String, dynamic> _posts;
  final DateTime _startDate;

  Map<String, dynamic> get posts => _posts;
  int get dayLength => _posts.length;
  DateTime get startDate => _startDate;

  static Future<AllVegePosts> init() async {
    final posts = await Database.loadAllPostLocal();
    final startDate = await Database.loadStartDate();
    return AllVegePosts(posts, startDate);
  }

  Future<void> update() async {
    _posts = await Database.loadAllPostLocal();
    notifyListeners();
  }
}

class DailyVegePosts with ChangeNotifier {

  DailyVegePosts(
    this._allPosts,
    DateTime date,
  ) {
    init(date);
  }
  
  final AllVegePosts _allPosts;
  late String _date;
  late List<VegePost> _posts;

  String get date => _date;
  List<VegePost> get posts => _posts;

  void init(DateTime date) {
    _date = DateFormat('yyyy/MM/dd').format(date);
    final dailyPostsJson = _allPosts.posts[_date] as String?;
    if (dailyPostsJson != null) {
      final targetPosts = jsonDecode(dailyPostsJson) as List<dynamic>;
      _posts = targetPosts.map<VegePost>((dynamic val) {
        final postJson = json.decode(val as String) as Map<String, dynamic>;
        return VegePost.fromJson(postJson);
      }).toList();
    } else {
      _posts = <VegePost>[];
    }
  }

  Future<void> _reflect() async {
    final result = await Database.addPostLocal(this);
    if (result) {
      await _allPosts.update();
    } else {
      _posts.removeLast();
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

  void printTest() {
    print(_allPosts._posts);
  }
}