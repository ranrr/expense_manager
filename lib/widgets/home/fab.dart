import 'package:expense_manager/widgets/record_entry/record_add.dart';
import 'package:flutter/material.dart';

class Fab extends StatelessWidget {
  const Fab({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddRecord(date: date)),
        ),
      },
      tooltip: 'Add Expense or Income',
      child: const Icon(Icons.add),
    );
  }
}
