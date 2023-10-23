import 'package:flutter/material.dart';

class RecordProvider with ChangeNotifier {
  String? account;
  String? type;
  String amount = "";
  String category = "";
  String? subCategory;
  DateTime date = DateTime.now();
  String? description;

  final List<bool> typeSelected = <bool>[true, false];
  setRecordType(int index) {
    for (int i = 0; i < typeSelected.length; i++) {
      typeSelected[i] = (i == index);
    }
    notifyListeners();
  }

  setDate(DateTime dateSelected) {
    date = dateSelected;
    notifyListeners();
  }

  setAmount(String inputAmount) {
    amount = inputAmount;
    notifyListeners();
  }

  setAccount(String? accountClicked) {
    account = account;
    notifyListeners();
  }

  setCategory(String categoryClicked) {
    category = categoryClicked;
    notifyListeners();
  }
}
