import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/widgets/util/settings_loader.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPanel extends StatelessWidget {
  const ResetPanel({super.key});

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
                    "This will delete all data. Please proceed after backup."),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: ResetAppData(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
  void dispose() {
    loading = false;
    super.dispose();
  }

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
            if (mounted) {
              setState(() {
                loading = false;
              });
            }
          },
          child: const Text("Reset App"),
        ),
      ],
    );
  }
}
