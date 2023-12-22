import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/widgets/util/record_list.dart';
import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({
    super.key,
    required this.records,
  });

  final List<TxnRecord> records;

  @override
  Widget build(BuildContext context) {
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
