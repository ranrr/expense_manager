import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class AccountsProvider with ChangeNotifier {
  AccountsProvider._();

  static final AccountsProvider provider = AccountsProvider._();

  List<String> accounts = [];
  String accountSelected = allAccountsName;
  int accountSelectedIndex = 0;

  init() async {
    accounts.addAll(await DBProvider.db.getAppAccounts());
    accountSelected =
        await DBProvider.db.getAppProperty(selectedAccountProperty);
    accountSelectedIndex = accounts.indexOf(accountSelected);
  }

  updateAccountSelected(String userSelectedAccount) {
    accountSelected = userSelectedAccount;
    DBProvider.db.account = userSelectedAccount;
    DBProvider.db.updateAppProperty(
        propertyName: selectedAccountProperty,
        propertyValue: userSelectedAccount);
    notifyListeners();
  }
}
