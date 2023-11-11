import 'dart:io';

import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        // body: ListView(
        //   shrinkWrap: true,
        //   children: const [
        //     Backup(),
        //     Restore(),
        //     ResetAppData(),
        //     LoadData(),
        //   ],
        // ),

        body: SingleChildScrollView(
          child: Container(
            child: ExpansionPanelList(
              children: [
                ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const ListTile(
                      title: Text("Backup"),
                    );
                  },
                  body: ListTile(
                      title: const Text("item.expandedValue"),
                      subtitle: const Text(
                          'To delete this panel, tap the trash can icon'),
                      trailing: const Icon(Icons.delete),
                      onTap: () {}),
                )
              ],
            ),
          ),
        ));
  }
}

class Restore extends StatelessWidget {
  const Restore({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.read<Accounts>();
    return GestureDetector(
      onTap: () async {
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
      child: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("Restore"),
          ),
        ),
      ),
    );
  }
}

class ResetAppData extends StatelessWidget {
  const ResetAppData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.read<Accounts>();
    return GestureDetector(
      onTap: () async {
        await DBProvider.db.resetDB();
        await dashboardProvider.updateDashboard();
        await accountsProvider.refresh();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text("App Reset Successful."),
              ),
              behavior: SnackBarBehavior.floating,
              margin: EdgeInsets.all(30),
              shape: StadiumBorder(),
              duration: Duration(milliseconds: 2000),
            ),
          );
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("Reset App"),
          ),
        ),
      ),
    );
  }
}

class LoadData extends StatelessWidget {
  const LoadData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.read<Accounts>();
    return GestureDetector(
      onTap: () async {
        await DBProvider.db.loadData();
        await dashboardProvider.updateDashboard();
        await accountsProvider.refresh();
      },
      child: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("Load Data"),
          ),
        ),
      ),
    );
  }
}

class Backup extends StatelessWidget {
  const Backup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
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
              shape: const StadiumBorder(),
              duration: const Duration(milliseconds: 2000),
            ),
          );
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(18.0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Text("Backup"),
          ),
        ),
      ),
    );
  }
}
