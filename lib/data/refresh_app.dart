import 'package:flutter/material.dart';

class RefreshApp with ChangeNotifier {
  DateTime now = DateTime.now();
  update() {
    now = DateTime.now();
    notifyListeners();
  }
}
