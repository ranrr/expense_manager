import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/widgets/dashboard/current_balance.dart';
import 'package:expense_manager/widgets/dashboard/grid.dart';
import 'package:expense_manager/widgets/dashboard/recent_transactions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardData = context.watch<DashboardData>();
    return Column(
      children: [
        CurrentBalance(balance: dashboardData.balance),
        DashboardGrid(data: dashboardData),
        const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 8, 8, 8),
              child: Text(
                "Recent Transactions",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        const RecentTransactions(),
      ],
    );
  }
}
