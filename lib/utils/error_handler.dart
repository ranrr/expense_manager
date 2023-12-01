import 'dart:io';

import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

void registerErrorHandler() {
  FlutterError.onError = (details) {
    if (kDebugMode) {
      print('****************************************************');
      print(details.exception); // the uncaught exception
      print(details.stack); // the stack trace at the time
      print('****************************************************');
    }
    logErrorToFile([details.exception, details.stack]);
    showSnackBar("Error Occured. 1"); //TODO edit text
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<Categories>().setLoader(false);
      navigatorKey.currentContext!.read<Accounts>().setLoader(false);
    }
    tryPop();
    FlutterError.presentError;
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (kDebugMode) {
      print('****************************************************');
      print(error); // the uncaught exception
      print(stack); // the stack trace at the time
      print('****************************************************');
    }
    logErrorToFile([error, stack]);
    showSnackBar("Error Occured.");
    if (navigatorKey.currentContext != null) {
      navigatorKey.currentContext!.read<Categories>().setLoader(false);
      navigatorKey.currentContext!.read<Accounts>().setLoader(false);
    }
    tryPop();
    return true;
  };
}

logErrorToFile(List<dynamic> args) async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String filePath = join(documentsDirectory.path, 'error.txt');
  File file = File(filePath);
  if (!await file.exists()) {
    await file.create();
  }
  IOSink sink = file.openWrite(mode: FileMode.append);
  for (var arg in args) {
    sink.write(arg);
    sink.write('\n');
  }
  await sink.close();
}

tryPop() {
  if (navigatorKey.currentState != null) {
    navigatorKey.currentState!.canPop()
        ? navigatorKey.currentState!.pop()
        : null;
  }
}
