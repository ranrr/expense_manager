import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountSelect extends StatelessWidget {
  const AccountSelect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.watch<RecordProvider>();
    Accounts accountsProvider = context.read<Accounts>();
    List<String> displayAccounts = [...accountsProvider.accounts];
    //To remove 'all' accounts key from the list.
    //last item is removed because, fetching from DB is sorted by 'id desc' and all accounts is added to DB during install
    displayAccounts.removeLast();
    //get the account selected in home page
    String accountSelected = accountsProvider.accountSelected;
    int accountIndex = displayAccounts.indexOf(accountSelected);
    //if the account selected in home page is 'all' accounts,
    //select index 0 in drop down initially and set in provider
    if (accountSelected == allAccountsName) {
      recordProvider.account = displayAccounts[0];
      accountIndex = 0;
    }

    return DropdownButtonFormField<String>(
      alignment: AlignmentDirectional.bottomEnd,
      value: displayAccounts[accountIndex],
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
      items: displayAccounts.map(
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
