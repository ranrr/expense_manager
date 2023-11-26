import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSelect extends StatelessWidget {
  final String account;
  const AccountSelect({
    super.key,
    required this.account,
  });

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.read<RecordProvider>();
    print('**********************account build');
    final controller = TextEditingController();
    controller.text = account;

    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () async {
        var value = await showDialog<String?>(
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
      decoration: recordFormDecoration(
          text: "Account", iconData: Icons.account_box_sharp),
    );
  }
}
