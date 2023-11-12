import 'dart:io';

import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class Restore extends StatelessWidget {
  const Restore({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.read<Accounts>();
    return ElevatedButton(
      onPressed: () async {
        // Destination path - app documents directory
        var appDB = await getApplicationDocumentsDirectory();
        var dbDestinationPath = join(appDB.path, 'expensemanager.db');

        // file picker path to be tested in device **********************
        // FilePickerResult? result = await FilePicker.platform.pickFiles();

        // if (result != null) {
        //   File source = File(result.files.single.path!);
        //   await source.copy(dbPath);
        // } else {
        //   // User canceled the picker
        // }
        // file picker path to be tested in device **********************

        //copy from path
        File sourceDB = File(
            "/storage/emulated/0/Android/data/com.example.expense_manager/files/downloads/expensemanager.db");
        var file = await sourceDB.copy(dbDestinationPath);
        print("copied file exists - ${file.existsSync()}");

        //refresh app
        await dashboardProvider.updateDashboard();
        await accountsProvider.refresh();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text("Data Restore Successful."),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(30),
              shape: StadiumBorder(),
              duration: Duration(milliseconds: 2000),
            ),
          );
        }
      },
      child: const Text("Restore"),
    );
  }
}
