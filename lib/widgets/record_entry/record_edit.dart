import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/record.dart';
import 'package:expense_manager/widgets/record_entry/record_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditRecord extends StatelessWidget {
  final int id;
  const EditRecord({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    Accounts accProvider = context.read<Accounts>();
    return FutureBuilder<Record>(
      future: DBProvider.db.getRecordById(id),
      builder: (BuildContext context, AsyncSnapshot<Record> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          Record rec = snapshot.data!;
          widget = EditRecordForm(accProvider: accProvider, rec: rec);
        } else if (snapshot.hasError) {
          widget = Container();
        } else {
          widget = Container();
        }
        return widget;
      },
    );
  }
}

class EditRecordForm extends StatelessWidget {
  const EditRecordForm({
    super.key,
    required this.accProvider,
    required this.rec,
  });

  final Accounts accProvider;
  final Record rec;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Transaction'),
      ),
      body: ChangeNotifierProvider<RecordProvider>(
        create: (context) => RecordProvider.edit(accProvider.accounts, rec),
        child: const RecordForm(),
      ),
    );
  }
}
