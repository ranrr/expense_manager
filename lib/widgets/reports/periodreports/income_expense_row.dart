import 'package:expense_manager/utils/widget_utils.dart';
import 'package:flutter/material.dart';

class IncomeExpenseRow extends StatelessWidget {
  final int income;
  final int expense;
  const IncomeExpenseRow({
    required this.income,
    required this.expense,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Income - ${formatNumber(income)}",
          style: const TextStyle(fontSize: 12),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            width: 2,
            height: 16,
            decoration: const BoxDecoration(color: Colors.black),
          ),
        ),
        Text(
          "Expense - ${formatNumber(expense)}",
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
