import 'package:flutter/material.dart';
import 'package:freshwatch/features/database.dart';

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

class AllVegePosts {

  static Future<AllVegePosts> init() async {
    final allPosts = await Database.loadAllPostLocal();
    final instance = AllVegePosts()
      .._posts = allPosts;
    return instance;
  }

  late Map<String, dynamic> _posts;
  Map<String, dynamic> get posts => _posts;
}

class DailyVegePosts with ChangeNotifier {

  DailyVegePosts(
    this._date,
    this._posts,
  );
  
  final String _date;
  List<VegePost> _posts;

  String get date => _date;
  List<VegePost> get posts => _posts;

  void addPost(VegePost newPost) {
    _posts.add(newPost);
    notifyListeners();
  }
}