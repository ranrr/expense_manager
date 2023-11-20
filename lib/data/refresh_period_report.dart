import 'package:flutter/material.dart';

class RefreshPeriodReport with ChangeNotifier {
  DateTime now = DateTime.now();
  refresh() {
    now = DateTime.now();
    notifyListeners();
  }
}
