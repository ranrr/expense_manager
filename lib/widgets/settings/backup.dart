import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Backup extends StatelessWidget {
  const Backup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Source
        Directory documentsDirectory = await getApplicationDocumentsDirectory();
        String dbPath = join(documentsDirectory.path, "expensemanager.db");
        File sourceDB = File(dbPath);

        //Destination path
        Directory? copyTo =
            await getDownloadsDirectory(); //getExternalStorageDirectory();
        if ((await copyTo!.exists())) {
          var status = await Permission.storage.status;
          if (!status.isGranted) {
            await Permission.storage.request();
          }
        }
        String copyPath = join(copyTo.path, "expensemanager.db");

        //copy source file to destination path
        var file = await sourceDB.copy(copyPath);
        print("**************************");
        print("copied to $copyPath");
        print("Destination file exists - ${file.existsSync()}");
        print("**************************");

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Text("Backup saved in $copyPath"),
              ),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(30),
              // shape: const StadiumBorder(),
              duration: const Duration(milliseconds: 8000),
            ),
          );
        }
      },
      child: const Text("Backup"),
    );
  }
}
