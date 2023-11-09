import 'package:expense_manager/data/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSelect extends StatelessWidget {
  const AccountSelect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.watch<RecordProvider>();

    final controller = TextEditingController();
    controller.text = recordProvider.account;

    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        var value = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text('Select Account'),
              children: recordProvider.accounts
                  .map(
                    (acc) => SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, acc);
                      },
                      child: Text(acc),
                    ),
                  )
                  .toList(),
            );
          },
        );
        recordProvider.setAccount(value);
      },
      decoration: InputDecoration(
        labelText: "Account",
        icon: const Icon(
          Icons.account_box_sharp,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: .75, color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.blue),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: Colors.red),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
