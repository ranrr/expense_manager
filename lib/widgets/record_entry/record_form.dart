import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/widgets/record_entry/account_select.dart';
import 'package:expense_manager/widgets/record_entry/action_buttons.dart';
import 'package:expense_manager/widgets/record_entry/amount.dart';
import 'package:expense_manager/widgets/record_entry/category_select.dart';
import 'package:expense_manager/widgets/record_entry/description.dart';
import 'package:expense_manager/widgets/record_entry/record_type_date.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordForm extends StatelessWidget {
  const RecordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
            const RecordTypeAndDate(),
            const Padding(padding: EdgeInsets.all(10)),
            Selector<RecordProvider, String>(
              selector: (context, provider) => provider.amount,
              builder: (context, amt, _) {
                return AmountInput(amount: amt);
              },
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Selector<RecordProvider, String>(
              selector: (context, provider) => provider.account,
              builder: (context, acc, _) {
                return AccountSelect(account: acc);
              },
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Selector<RecordProvider, String>(
              selector: (context, provider) => provider.categoryText,
              builder: (context, catText, _) {
                return CategorySelect(categoryText: catText);
              },
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Selector<RecordProvider, String>(
              selector: (context, provider) => provider.description,
              builder: (context, desc, _) {
                return Description(description: desc);
              },
            ),
            const Padding(padding: EdgeInsets.all(10)),
            const ActionButtons(),
          ],
        ),
      ),
    );
  }
}
