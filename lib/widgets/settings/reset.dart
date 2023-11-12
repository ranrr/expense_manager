import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetAppData extends StatelessWidget {
  const ResetAppData({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.read<Accounts>();
    return ElevatedButton(
      onPressed: () async {
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
      child: const Text("Reset App"),
    );
  }
}
