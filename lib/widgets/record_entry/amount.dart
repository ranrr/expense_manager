import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AmountInput extends StatelessWidget {
  const AmountInput({
    super.key,
    required this.amount,
  });
  final String amount;

  @override
  Widget build(BuildContext context) {
    var recordProvider = context.read<RecordProvider>();
    return TextFormField(
      initialValue: recordProvider.amount,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(16)
      ],
      onChanged: (String value) {
        recordProvider.setAmount(value);
      },
      decoration: recordFormDecoration(text: "Amount", iconData: Icons.money),
    );
  }
}
