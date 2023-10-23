import 'package:expense_manager/model/record.dart';
import 'package:flutter/material.dart';

class RecordProvider with ChangeNotifier {
  RecordAction action;

  String? id;
  String account;
  final List<bool> typeSelected = <bool>[true, false];
  String type;
  String amount = "";
  String category = "";
  String subCategory = "";
  DateTime date = DateTime.now();
  String description = "";

  RecordProvider.add(String accountSelected, RecordAction recordAction)
      : type = "Expense",
        account = accountSelected,
        action = recordAction;

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
    if (accountClicked != null) {
      account = accountClicked;
      notifyListeners();
    }
  }

  setCategory(String categoryClicked) {
    category = categoryClicked.split(",")[0];
    subCategory = categoryClicked.split(",")[1];
    notifyListeners();
  }

  setDescription(String userDescription) {
    description = userDescription;
    notifyListeners();
  }

  addRecord() {
    print("*********************ADD******************");
  }

  deleteRecord() {
    print("*********************ADD******************");
  }
}
