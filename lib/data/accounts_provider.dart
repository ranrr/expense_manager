import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class Accounts with ChangeNotifier {
  Accounts._();

  static final Accounts provider = Accounts._();

  List<String> accounts = [];
  String accountSelected = allAccountsName;

  init() async {
    accounts.addAll(await DBProvider.db.getAppAccounts());
    accountSelected =
        await DBProvider.db.getAppProperty(selectedAccountProperty);
    print("***************AccountsProvider init Done... ***************");
  }

  updateAccountSelected(String userSelectedAccount) async {
    accountSelected = userSelectedAccount;
    DBProvider.db.account = userSelectedAccount;
    await DBProvider.db.updateAppProperty(
        propertyName: selectedAccountProperty,
        propertyValue: userSelectedAccount);
    notifyListeners();
  }
}
