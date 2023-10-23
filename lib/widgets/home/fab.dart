import 'package:expense_manager/widgets/record_entry/record_add.dart';
import 'package:flutter/material.dart';

class Fab extends StatelessWidget {
  const Fab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddRecord()),
        ),
      },
      tooltip: 'Add Expense or Income',
      child: const Icon(Icons.add),
    );
  }
}
