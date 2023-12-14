// import 'dart:io';

// import 'package:expense_manager/widgets/util/snack_bar.dart';
// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

//TODO check error handler

// void registerErrorHandler() {
//   FlutterError.onError = (details) {
//     if (kDebugMode) {
//       print('****************************************************');
//       print(details.exception); // the uncaught exception
//       print(details.stack); // the stack trace at the time
//       print('****************************************************');
//     }
//     logErrorToFile([details.exception, details.stack]);
//     showSnackBar("Error Occured.");
//     FlutterError.presentError;
//   };

//   PlatformDispatcher.instance.onError = (error, stack) {
//     if (kDebugMode) {
//       print('****************************************************');
//       print(error); // the uncaught exception
//       print(stack); // the stack trace at the time
//       print('****************************************************');
//     }
//     logErrorToFile([error, stack]);
//     showSnackBar("Error Occured.");
//     return true;
//   };
// }

// logErrorToFile(List<dynamic> args) async {
//   Directory documentsDirectory = await getApplicationDocumentsDirectory();
//   String filePath = join(documentsDirectory.path, 'error.txt');
//   File file = File(filePath);
//   if (!await file.exists()) {
//     await file.create();
//   }
//   IOSink sink = file.openWrite(mode: FileMode.append);
//   for (var arg in args) {
//     sink.write(arg);
//     sink.write('\n');
//   }
//   await sink.close();
// }
