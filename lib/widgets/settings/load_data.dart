import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadDataPanel extends StatelessWidget {
  const LoadDataPanel({
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
              Expanded(
                child: Text(
                    "This will load sample data that comes with App. Please take a backup of existing data. "),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: LoadData(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
  void dispose() {
    _isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.read<Accounts>();
    var chartProvider = context.read<RefreshCharts>();
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
            await chartProvider.refresh();
            await accountsProvider.refresh();
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
            }
            if (context.mounted && Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            }
          },
          child: const Text("Load Data"),
        ),
      ],
    );
  }
}
