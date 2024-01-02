import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/record_entry/record_copy.dart';
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
      onTapUp: (details) {
        var option = showCardMenu(context, details.globalPosition);
        option.then(
          (value) => {
            if (value == 'copy')
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CopyRecord(id: record.id!)))
              }
            else if (value == 'edit')
              {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditRecord(id: record.id!)))
              }
            else if (value == 'autofill')
              {
                showDialog<String?>(
                  context: context,
                  builder: (BuildContext context) {
                    return const InputAlertDialog(
                      header: autoFillHeader,
                      message: autoFillMessage,
                    );
                  },
                ).then(
                  (name) => {
                    if (name != null && name.isNotEmpty)
                      {
                        createAutoFillRecord(name, record)
                            .then((message) => showSnackBar(message))
                      }
                  },
                ),
              },
          },
        );
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

Future<String> showCardMenu(BuildContext context, Offset position) async {
  var option = await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(position.dx, position.dy - 50, 0, 0),
    items: const [
      PopupMenuItem<String>(
        value: 'edit',
        child: Text('Edit'),
      ),
      PopupMenuItem<String>(
        value: 'copy',
        child: Text('Copy'),
      ),
      PopupMenuItem<String>(
        value: 'autofill',
        child: SizedBox(width: 85, child: Text('Auto-Fill')),
      ),
    ],
  ).then(
    (value) {
      if (value != null) {
        return value;
      }
    },
  );
  return option ?? '';
}
