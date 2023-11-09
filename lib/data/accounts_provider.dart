import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

//Provider for the list of accounts in app
class Accounts with ChangeNotifier {
  Accounts._();

  static final Accounts provider = Accounts._();

  List<String> accounts = [];
  String accountSelected = allAccountsName;

  init() async {
    //TODO change addall, will create duplicates
    accounts.addAll(await DBProvider.db.getAppAccounts());
    accountSelected =
        await DBProvider.db.getAppProperty(selectedAccountProperty);
    DBProvider.db.account = accountSelected;
    print("***************AccountsProvider init Done... ***************");
  }

  //active account- selected account is saved in 'appproperty' table
  updateAccountSelected(String userSelectedAccount) async {
    accountSelected = userSelectedAccount;
    await DBProvider.db
        .updateSelectedAccount(selectedAccount: userSelectedAccount);
    notifyListeners();
  }
}
