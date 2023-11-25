import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/widgets/util/record_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    //watch - list has to be rebuilt on recrd actions.
    //inserted as a const widget in parent - so forced rebuild
    final dashboardData = context.watch<DashboardData>();
    List<TxnRecord> records = dashboardData.records;
    if (records.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("No Transactions"),
      );
    } else {
      return Expanded(child: RecordsList(records: records));
    }
  }
}
