import 'dart:ui';

import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void registerErrorHandler() {
  FlutterError.onError = (details) {
    print('****************************************************');
    print(details.exception); // the uncaught exception
    print(details.stack); // the stack trace at the time
    print('****************************************************');
    showSnackBar("Error Occured.");
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<Categories>().setLoader(false);
      navigatorKey.currentContext!.read<Accounts>().setLoader(false);
    }
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    print('****************************************************');
    print(error); // the uncaught exception
    print(stack); // the stack trace at the time
    print('****************************************************');
    showSnackBar("Error Occured.");
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<Categories>().setLoader(false);
      navigatorKey.currentContext!.read<Accounts>().setLoader(false);
    }
    return true;
  };
}
