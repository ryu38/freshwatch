import 'package:flutter/material.dart';

class DateModel with ChangeNotifier {

  DateModel() {
    init();
  }

  late DateTime _today;

  DateTime get today => _today;

  void init() {
    final now = DateTime.now();
    _today = DateTime(now.year, now.month, now.day + 1);
  }

  void update() {
    init();
    notifyListeners();
  }
}