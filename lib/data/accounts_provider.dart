import 'package:flutter/material.dart';

class AccountsProvider with ChangeNotifier {
  var accounts = ["Acc 1", "Acc 2"];
  int accountSelected = 0;
}
