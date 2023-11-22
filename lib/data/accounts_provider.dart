import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

//Provider for the list of accounts in app
class Accounts with ChangeNotifier {
  Accounts._();

  static final Accounts provider = Accounts._();

  List<String>? _accounts;
  String? _accountSelected;
  bool _loading = false;

  List<String> get accounts => _accounts ?? [];

  String get accountSelected => _accountSelected ?? allAccountsName;

  bool get loading => _loading;

  //util method to get list of real accounts without 'all'
  List<String> get realaccounts {
    List<String> acc = [...accounts];
    acc.remove(allAccountsName);
    return acc;
  }

  init() async {
    _accounts = await DBProvider.db.getAppAccounts();
    _accountSelected =
        await DBProvider.db.getAppProperty(selectedAccountProperty);
    DBProvider.db.account = accountSelected;
    debugPrint("***************AccountsProvider init Done... ***************");
  }

  refresh() async {
    await init();
    notifyListeners();
  }

  refreshAndStopLoader() async {
    await init();
    _loading = false;
    notifyListeners();
  }

  setLoader(bool loader) {
    _loading = loader;
    notifyListeners();
  }

  //active account- selected account is saved in 'appproperty' table
  updateAccountSelected(String userSelectedAccount) async {
    _accountSelected = userSelectedAccount;
    DBProvider.db.account = userSelectedAccount;
    await DBProvider.db
        .updateSelectedAccount(selectedAccount: userSelectedAccount);
    notifyListeners();
  }

  Future<String> addNewAccount(String newAccountName) async {
    String message;
    if (accounts.contains(newAccountName)) {
      message = "Account name already exists.";
    } else {
      setLoader(true);
      await DBProvider.db.addNewAccount(newAccountName);
      await refreshAndStopLoader();
      message = "Account added.";
    }
    return message;
  }

  Future<String> renameAccount(
      String oldAccountName, String newAccountName) async {
    String message;
    if (accounts.contains(newAccountName)) {
      message = "Account name already exists.";
    } else {
      setLoader(true);
      await DBProvider.db
          .renameAccountAndRecords(oldAccountName, newAccountName);
      await refreshAndStopLoader();
      message = "Account renamed.";
    }
    return message;
  }

  Future<String> deleteAccount(String account) async {
    setLoader(true);
    await DBProvider.db.deleteAccountAndRecords(account);
    await refreshAndStopLoader();
    String message = "Account deleted.";
    return message;
  }
}
