import 'package:expense_manager/data/add_record_provider.dart';
import 'package:expense_manager/widgets/record_entry/add_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddRecord extends StatelessWidget {
  const AddRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: ChangeNotifierProvider<RecordProvider>(
        create: (context) => RecordProvider(),
        child: const RecordForm(),
      ),
    );
  }
}
