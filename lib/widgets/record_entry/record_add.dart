import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/widgets/record_entry/record_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRecord extends StatelessWidget {
  const AddRecord({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    var accountsProvider = context.read<Accounts>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense / Income'),
      ),
      body: ChangeNotifierProvider<RecordProvider>(
        create: (context) => RecordProvider.add(
          accountsProvider.accounts,
          accountsProvider.accountSelected,
          date,
        ),
        child: const RecordForm(),
      ),
    );
  }
}
