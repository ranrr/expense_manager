import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/record.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class RecordProvider with ChangeNotifier {
  RecordAction action;
  String? id;
  String account;
  final List<bool> typeSelected = <bool>[true, false];
  String recordType;
  String amount = "";
  String category = "";
  String subCategory = "";
  DateTime date = DateTime.now();
  String description = "";

  RecordProvider.add(String accountSelected)
      : recordType = RecordType.expense.name,
        account = accountSelected,
        action = RecordAction.add;

  //TODO change this for edit, pargument should be a Record
  //check id also. id should be mandatory
  RecordProvider.edit(String accountSelected)
      : recordType = RecordType.expense.name,
        account = accountSelected,
        action = RecordAction.edit;

  List<String> _validate() {
    List<String> errors = [];
    if (amount.isEmpty) {
      errors.add("Amount");
    }
    if (category.isEmpty || category.length == 1) {
      errors.add("Category");
    }
    return errors;
  }

  setRecordType(int index) {
    for (int i = 0; i < typeSelected.length; i++) {
      typeSelected[i] = (i == index);
    }
    recordType =
        (index == 0) ? RecordType.expense.name : RecordType.income.name;
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

  (bool, List<String>) addRecord() {
    var errors = _validate();
    if (errors.isEmpty) {
      DBProvider.db.newRecord(Record(
          account: account,
          type: recordType,
          amount: int.parse(amount),
          category: category,
          subCategory: subCategory,
          date: date,
          description: description));
      return (true, errors);
    } else {
      return (false, errors);
    }
  }

  deleteRecord() {}
}
