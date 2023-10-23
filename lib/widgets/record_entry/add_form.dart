import 'package:expense_manager/widgets/record_entry/account_select.dart';
import 'package:expense_manager/widgets/record_entry/action_buttons.dart';
import 'package:expense_manager/widgets/record_entry/amount.dart';
import 'package:expense_manager/widgets/record_entry/category_select.dart';
import 'package:expense_manager/widgets/record_entry/description.dart';
import 'package:expense_manager/widgets/record_entry/type_date.dart';
import 'package:flutter/material.dart';

class RecordForm extends StatelessWidget {
  const RecordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: const <Widget>[
            RecordTypeAndDate(),
            Padding(padding: EdgeInsets.all(10)),
            AmountInput(),
            Padding(padding: EdgeInsets.all(10)),
            AccountSelect(),
            Padding(padding: EdgeInsets.all(10)),
            CategorySelect(),
            Padding(padding: EdgeInsets.all(10)),
            Description(),
            Padding(padding: EdgeInsets.all(10)),
            ActionButtons(),
          ],
        ),
      ),
    );
  }
}
