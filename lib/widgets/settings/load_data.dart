import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadData extends StatefulWidget {
  const LoadData({
    super.key,
  });

  @override
  State<LoadData> createState() => _LoadDataState();
}

class _LoadDataState extends State<LoadData> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.read<Accounts>();
    return Row(
      children: [
        if (_isLoading)
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          ),
        ElevatedButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
            });
            await DBProvider.db.loadData();
            await dashboardProvider.updateDashboard();
            await accountsProvider.refresh();
            setState(() {
              _isLoading = false;
            });
          },
          child: const Text("Load Data"),
        ),
      ],
    );
  }
}
