import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ErrorToast {

  static Future<bool?> show(String msg) async {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: Colors.red,
    );
  }
}