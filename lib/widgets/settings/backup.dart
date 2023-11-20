import 'dart:io';

import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/util/settings_loader.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BackupPanel extends StatelessWidget {
  const BackupPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Backup app database."),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Backup(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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

            // Source database
            Directory documentsDirectory =
                await getApplicationDocumentsDirectory();
            String dbPath = join(documentsDirectory.path, "expensemanager.db");
            File sourceDB = File(dbPath);

            //Destination path //getExternalStorageDirectory();
            Directory? copyTo = await getDownloadsDirectory();
            if ((await copyTo!.exists())) {
              var status = await Permission.storage.status;
              if (!status.isGranted) {
                status = await Permission.storage.request();
              }
              if (status.isGranted || kDebugMode) {
                String copyPath = join(copyTo.path, "expensemanager.db");
                //copy source database file to destination path
                var file = await sourceDB.copy(copyPath);
                print("**************************");
                print("copied to $copyPath");
                print("Destination file exists - ${file.existsSync()}");
                print("**************************");
                //save backup copied path for restore settings
                DBProvider.db.updateAppProperty(
                    propertyName: dbBackupPath, propertyValue: copyPath);
                showSnackBar("Backup saved in Downloads");
              } else {
                showSnackBar("Please provide permission.");
              }
            } else {
              showSnackBar("Path does not exist.");
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
