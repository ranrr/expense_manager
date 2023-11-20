import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class ExpenseTypeIndicator extends StatelessWidget {
  const ExpenseTypeIndicator({
    super.key,
    required this.recordType,
  });

  final String recordType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color:
            (recordType == RecordType.expense.name) ? Colors.red : Colors.green,
        borderRadius: BorderRadius.circular(7),
      ),
      constraints: const BoxConstraints(
        minWidth: 8,
        minHeight: 8,
      ),
    );
  }
}
