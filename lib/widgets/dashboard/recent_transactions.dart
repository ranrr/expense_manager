import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/model/record.dart';
import 'package:expense_manager/widgets/util/record_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardData = context.watch<DashboardData>();
    List<Record> records = dashboardData.records;
    return RecordsList(records: records);
  }
}
