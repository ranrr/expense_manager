import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class RecordProvider with ChangeNotifier {
  //TODO check if all strings are trimmed before using
  RecordAction action;
  List<String> accounts;
  int? id;
  String account;
  List<bool> typeSelected = <bool>[true, false];
  String recordType;
  String amount = "";
  String category = "";
  String subCategory = "";
  DateTime date =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String description = "";

  RecordProvider.add(List<String> allAccounts, String accountSelected)
      : accounts = [...allAccounts]..remove(allAccountsName),
        recordType = RecordType.expense.name,
        account = (accountSelected == allAccountsName)
            ? allAccounts[0]
            : accountSelected,
        action = RecordAction.add;

  // TODO change this for edit, argument should be a Record
  // check id also. id should be mandatory
  RecordProvider.edit(List<String> allAccounts, TxnRecord rec)
      : accounts = [...allAccounts]..remove(allAccountsName),
        account = rec.account,
        id = rec.id,
        recordType = rec.type,
        typeSelected = (rec.type == RecordType.expense.name)
            ? [true, false]
            : [false, true],
        amount = rec.amount.toString(),
        category = rec.category,
        subCategory = rec.subCategory,
        date = rec.date,
        description = rec.description,
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
    resetCategory();
    notifyListeners();
  }

  resetCategory() {
    category = "";
    subCategory = "";
  }

  setDate(DateTime dateSelected) {
    date = DateTime(dateSelected.year, dateSelected.month, dateSelected.day);
    notifyListeners();
  }

  setAmount(String inputAmount) {
    amount = inputAmount.trim();
    notifyListeners();
  }

  setAccount(String? accountClicked) {
    if (accountClicked != null) {
      account = accountClicked;
      notifyListeners();
    }
  }

  setCategory(String categoryClicked) {
    category = categoryClicked.split(",")[0].trim();
    subCategory = categoryClicked.split(",")[1].trim();
    notifyListeners();
  }

  setDescription(String userDescription) {
    description = userDescription.trim();
    notifyListeners();
  }

  Future<(bool, List<String>)> addRecord() async {
    var errors = _validate();
    if (errors.isNotEmpty) {
      return (false, errors);
    }
    if (id == null) {
      await DBProvider.db.newRecord(TxnRecord(
          account: account,
          type: recordType,
          amount: int.parse(amount),
          category: category,
          subCategory: subCategory,
          date: date,
          description: description));
      return (true, errors);
    } else {
      await DBProvider.db.deleteRecordById(id!);
      await DBProvider.db.newRecord(TxnRecord(
          account: account,
          type: recordType,
          amount: int.parse(amount),
          category: category,
          subCategory: subCategory,
          date: date,
          description: description));
      return (true, errors);
    }
  }

  deleteRecord(int id) async {
    await DBProvider.db.deleteRecordById(id);
  }
}
