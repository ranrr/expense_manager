import 'dart:io';

import 'package:expense_manager/widgets/util/settings_loader.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Backup extends StatefulWidget {
  const Backup({
    super.key,
  });

  @override
  State<Backup> createState() => _BackupState();
}

class _BackupState extends State<Backup> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (loading) const SettingsLoader(),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              loading = true;
            });
            // Source
            Directory documentsDirectory =
                await getApplicationDocumentsDirectory();
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
              showSnackBar(context, "Backup saved in $copyPath");
            }
            setState(() {
              loading = false;
            });
          },
          child: const Text("Backup"),
        ),
      ],
    );
  }
}
