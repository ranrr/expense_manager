import 'package:expense_manager/dataaccess/database.dart';
import 'package:flutter/material.dart';

class AccountsProvider with ChangeNotifier {
  var accounts = ["Acc 1", "Acc 2"];
  int accountSelectedIndex = 0;

  updateAccountSelected(String accountselected) {
    DBProvider.db.account = accountselected;
  }
}
