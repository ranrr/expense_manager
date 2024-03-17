import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/model/autofill.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/record_entry/action_buttons.dart';
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
    var amtController = TextEditingController();
    amtController.text = amount;
    amtController.selection =
        TextSelection.collapsed(offset: amtController.text.length);
    return TextFormField(
      autofocus: true,
      controller: amtController,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
        LengthLimitingTextInputFormatter(16)
      ],
      onChanged: (String value) {
        recordProvider.setAmount(value);
      },
      decoration: InputDecoration(
        labelText: "Amount",
        icon: const AddAmountAutoFill(),
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

class AddAmountAutoFill extends StatelessWidget {
  const AddAmountAutoFill({super.key});

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.read<RecordProvider>();
    return FutureBuilder<List<AutoFill>>(
      future: getAllAutoFillRecords(),
      builder: (BuildContext context, AsyncSnapshot<List<AutoFill>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          List<AutoFill> records = snapshot.data!;
          widget = GestureDetector(
            onTap: () async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  if (records.isEmpty) {
                    return const NoAutoFillRecords();
                  } else {
                    return AutoFillRecordsList(
                      records: records,
                      recordProvider: recordProvider,
                    );
                  }
                },
              );
            },
            child: const Icon(Icons.money),
          );
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
