import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/widgets/util/record_tile.dart';
import 'package:flutter/material.dart';

//list view of records that are already saved in db
class RecordsList extends StatelessWidget {
  const RecordsList({
    super.key,
    required this.records,
  });

  final List<TxnRecord> records;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        return RecordTile(record: records[index]);
      },
    );
  }
}
