import 'dart:io';

import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/util/settings_loader.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class RestorePanel extends StatelessWidget {
  const RestorePanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Restore app database from backup."),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Restore(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Restore extends StatefulWidget {
  const Restore({
    super.key,
  });

  @override
  State<Restore> createState() => _RestoreState();
}

class _RestoreState extends State<Restore> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.read<Accounts>();
    var categoryProvider = context.read<Categories>();

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

            // Destination path - app documents directory
            var appDB = await getApplicationDocumentsDirectory();
            var dbDestinationPath = join(appDB.path, 'expensemanager.db');

            //copy from backed up file path
            if (kDebugMode) {
              String backupPath =
                  await DBProvider.db.getAppProperty(dbBackupPath);
              if (backupPath.isEmpty) {
                backupPath =
                    "/storage/emulated/0/Android/data/com.example.expense_manager/files/downloads/expensemanager.db";
              }
              File sourceDB = File(backupPath);
              if (sourceDB.existsSync()) {
                var file = await sourceDB.copy(dbDestinationPath);
                showSnackBar("Data Restore Successful.");
                print("copied file exists - ${file.existsSync()}");
              } else {
                showSnackBar("Path does not exist.");
              }
            } else {
              // file picker path
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                File source = File(result.files.single.path!);
                await source.copy(dbDestinationPath);
                //refresh app
                await dashboardProvider.updateDashboard();
                await accountsProvider.refresh();
                await categoryProvider.updateCategories();
                showSnackBar("Data Restore Successful.");
              }
            }
            setState(() {
              loading = false;
            });
          },
          child: const Text("Restore"),
        ),
      ],
    );
  }
}
