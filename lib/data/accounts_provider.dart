import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

//Provider for the list of accounts in app
class Accounts with ChangeNotifier {
  Accounts._();

  static final Accounts provider = Accounts._();

  List<String>? _accounts;
  String? _accountSelected;

  List<String> get accounts => _accounts ?? [];
  List<String> get realaccounts {
    List<String> acc = [...accounts];
    acc.remove(allAccountsName);
    return acc;
  }

  String get accountSelected => _accountSelected ?? allAccountsName;

  init() async {
    _accounts = await DBProvider.db.getAppAccounts();
    _accountSelected =
        await DBProvider.db.getAppProperty(selectedAccountProperty);
    DBProvider.db.account = accountSelected;
    print("***************AccountsProvider init Done... ***************");
  }

  refresh() async {
    await init();
    notifyListeners();
  }

  //active account- selected account is saved in 'appproperty' table
  updateAccountSelected(String userSelectedAccount) async {
    _accountSelected = userSelectedAccount;
    await DBProvider.db
        .updateSelectedAccount(selectedAccount: userSelectedAccount);
    notifyListeners();
  }
}
