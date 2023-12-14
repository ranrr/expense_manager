import 'dart:io';

import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/widgets/util/settings_loader.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:file_picker/file_picker.dart';
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
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.read<Accounts>();
    var categoryProvider = context.read<Categories>();
    var chartProvider = context.read<RefreshCharts>();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (loading) const SettingsLoader(),
        ElevatedButton(
          onPressed: () async {
            startLoader();

            // Destination path - app documents directory
            Directory appDB = await getApplicationDocumentsDirectory();
            var dbDestinationPath = join(appDB.path, 'expensemanager.db');

            // copy from backed up file path - file picker path
            FilePickerResult? result;
            try {
              result = await FilePicker.platform.pickFiles();
            } catch (e) {
              stopLoader();
              showSnackBar("Please provide permission.");
            }

            if (result != null) {
              File source = File(result.files.single.path!);

              File currentDB = File(dbDestinationPath);
              if (currentDB.existsSync()) {
                await DBProvider.db.closeDatabase();
                currentDB.deleteSync();
              }

              await source.copy(dbDestinationPath);
              await DBProvider.db.initDB();

              //refresh app
              await dashboardProvider.updateDashboard();
              await accountsProvider.refresh();
              await categoryProvider.updateCategories();
              await chartProvider.refresh();
              showSnackBar("Data Restore Successful.");
            }
            stopLoader();
          },
          child: const Text("Restore"),
        ),
      ],
    );
  }
}
