import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:expense_manager/model/record.dart';

class RecordTile extends StatelessWidget {
  final Record record;
  const RecordTile({required this.record, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(8, 5, 8, 0),
      child: ListTile(
        isThreeLine: true,
        subtitle: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Text(
            "${record.account}  |  ${record.category} ${(record.subCategory.isEmpty) ? "" : " | "} ${record.subCategory} \n${record.description}",
            style: const TextStyle(fontSize: 12),
          ),
        ),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: (record.type == RecordType.expense.name)
                    ? Colors.red
                    : Colors.green,
                borderRadius: BorderRadius.circular(7),
              ),
              constraints: const BoxConstraints(
                minWidth: 8,
                minHeight: 8,
              ),
            ),
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
                  record.amount.toString(),
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
