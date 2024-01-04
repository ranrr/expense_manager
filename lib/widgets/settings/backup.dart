import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/util/settings_loader.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
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
              Expanded(
                  child: Text(
                      "Backup app database. Backup will be saved in Downloads. ")),
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
  void dispose() {
    loading = false;
    super.dispose();
  }

  void stopLoader() {
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  void startLoader() {
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (loading) const SettingsLoader(),
        ElevatedButton(
          onPressed: () async {
            startLoader();
            try {
              DeviceInfoPlugin deviceinfo = DeviceInfoPlugin();
              AndroidDeviceInfo android = await deviceinfo.androidInfo;
              if (android.version.sdkInt < 33) {
                var status = await Permission.storage.status;
                if (!status.isGranted) {
                  status = await Permission.storage.request();
                }
                if (status.isGranted) {
                  saveBackup();
                } else {
                  showSnackBar("Please provide permission.");
                }
              } else {
                saveBackup();
              }
            } finally {
              stopLoader();
            }

            if (context.mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: const Text("Backup"),
        ),
      ],
    );
  }

  void saveBackup() async {
    //close the database
    await DBProvider.db.closeDatabase();
    // Source database
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDirectory.path, "expensemanager.db");
    File sourceDB = File(dbPath);
    //Destination path
    //hard coded downloads destination for android
    Directory copyToPathDir = Directory('/storage/emulated/0/Download');
    if ((await copyToPathDir.exists())) {
      String copyPath = join(copyToPathDir.path, "expensemanager.db");
      //copy source database file to destination path
      await sourceDB.copy(copyPath);
      await DBProvider.db.initDB();
      //save backup copied path for restore settings
      await DBProvider.db.updateAppProperty(
          propertyName: dbBackupPath, propertyValue: copyPath);
      showSnackBar("Backup saved in Downloads");
    } else {
      showSnackBar("App could not find Downloads path.");
    }
  }
}
