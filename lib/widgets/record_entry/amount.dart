import 'package:expense_manager/data/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AmountInput extends StatelessWidget {
  const AmountInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var recordProvider = context.watch<RecordProvider>();
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
      //TODO extract this decoration
      decoration: InputDecoration(
        labelText: "Amount",
        icon: const Icon(
          Icons.money,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 0.75, color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.blue),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 0.5, color: Colors.red),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
