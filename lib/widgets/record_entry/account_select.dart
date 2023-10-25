import 'package:expense_manager/data/accounts_provider.dart';
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
    AccountsProvider accountsProvider = context.watch<AccountsProvider>();
    List<String> accounts = accountsProvider.accounts;
    String accountSelected = accountsProvider.accountSelected;
    int accountIndex = accounts.indexOf(accountSelected);

    return DropdownButtonFormField<String>(
      alignment: AlignmentDirectional.bottomEnd,
      value: accounts[accountIndex],
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
      onChanged: (String? value) {
        recordProvider.setAccount(value);
      },
      items: accounts.map(
        (String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        },
      ).toList(),
    );
  }
}
