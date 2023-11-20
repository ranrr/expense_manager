import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/widgets/util/settings_loader.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetAppData extends StatefulWidget {
  const ResetAppData({
    super.key,
  });

  @override
  State<ResetAppData> createState() => _ResetAppDataState();
}

class _ResetAppDataState extends State<ResetAppData> {
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
            await DBProvider.db.resetDB();
            await dashboardProvider.updateDashboard();
            await accountsProvider.refresh();
            await categoryProvider.updateCategories();
            showSnackBar("App Reset Successful.");
            setState(() {
              loading = true;
            });
          },
          child: const Text("Reset App"),
        ),
      ],
    );
  }
}
