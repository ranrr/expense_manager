import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: () async {
              Directory documentsDirectory =
                  await getApplicationDocumentsDirectory();
              String dbPath =
                  join(documentsDirectory.path, "expensemanager.db");
              File sourceDB = File(dbPath);

              Directory? copyTo = await getExternalStorageDirectory();
              if ((await copyTo!.exists())) {
                var status = await Permission.storage.status;
                if (!status.isGranted) {
                  await Permission.storage.request();
                }
              } else {
                if (await Permission.storage.request().isGranted) {
                  // Either the permission was already granted before or the user just granted it.
                  await copyTo.create();
                } else {
                  print('Please give permission');
                }
              }

              String copyPath = join(copyTo.path, "expensemanager.db");
              await sourceDB.copy(copyPath);
              print("copied to $copyPath");
            },
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text("Backup"),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Restore"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
