import 'package:flutter/material.dart';

class RefreshPeriodReport with ChangeNotifier {
  DateTime now = DateTime.now();
  refresh() async {
    now = DateTime.now();
    notifyListeners();
  }
}
