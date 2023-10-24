import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/widgets/record_entry/add_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRecord extends StatelessWidget {
  const AddRecord({super.key});

  @override
  Widget build(BuildContext context) {
    var accountsProvider = context.read<AccountsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: ChangeNotifierProvider<RecordProvider>(
        create: (context) => RecordProvider.add(
          accountsProvider.accounts[accountsProvider.accountSelectedIndex],
        ),
        child: const RecordForm(),
      ),
    );
  }
}
