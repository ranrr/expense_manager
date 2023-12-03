import 'package:flutter/material.dart';

class RefreshCharts with ChangeNotifier {
  DateTime now = DateTime.now();
  refresh() async {
    now = DateTime.now();
    notifyListeners();
  }
}
