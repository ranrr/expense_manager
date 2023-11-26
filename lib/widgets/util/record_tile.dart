import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/record_entry/record_edit.dart';
import 'package:expense_manager/widgets/util/expense_type_indicator.dart';
import 'package:expense_manager/widgets/util/input_alert.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';

class RecordTile extends StatelessWidget {
  final TxnRecord record;
  const RecordTile({required this.record, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditRecord(id: record.id!)),
        );
      },
      onLongPress: () async {
        var name = await showDialog<String?>(
          context: context,
          builder: (BuildContext context) {
            return const InputAlertDialog(
              header: autoFillHeader,
              message: autoFillMessage,
            );
          },
        );
        if (name != null && name.isNotEmpty) {
          var message = await createAutoFillRecord(name, record);
          showSnackBar(message);
        }
      },
      child: RecordCard(record: record),
    );
  }
}

class RecordCard extends StatelessWidget {
  const RecordCard({
    super.key,
    required this.record,
  });

  final TxnRecord record;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 5, 8, 0),
      child: ListTile(
        isThreeLine: true,
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: RecordDisplayText(record: record),
        ),
        title: Row(
          children: [
            ExpenseTypeIndicator(recordType: record.type),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getDateText(record.date),
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  formatNumber(record.amount),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RecordDisplayText extends StatelessWidget {
  const RecordDisplayText({
    super.key,
    required this.record,
  });

  final TxnRecord record;

  @override
  Widget build(BuildContext context) {
    return Text(
      "${record.account}  |  ${record.category}  |  ${record.subCategory} \n${record.description}",
      style: const TextStyle(fontSize: 12),
    );
  }
}
