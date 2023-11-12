import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageAccounts extends StatefulWidget {
  const ManageAccounts({
    super.key,
  });

  @override
  State<ManageAccounts> createState() => _ManageAccountsState();
}

class _ManageAccountsState extends State<ManageAccounts> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.watch<Accounts>();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: accountsProvider.realaccounts.length,
      itemBuilder: (BuildContext context, int index) {
        String account = accountsProvider.realaccounts[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          child: ListTile(
            leading: Text(
              account,
              style: const TextStyle(fontSize: 16),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                GestureDetector(
                  onTap: () async {
                    var newAccountName = await showDialog<String>(
                      context: context,
                      builder: (BuildContext context) {
                        final accController = TextEditingController();
                        return AlertDialog(
                          title: const Text('Rename Account'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Enter new Account name'),
                              TextFormField(
                                controller: accController,
                              )
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, ''),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.pop(context, accController.text),
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    if (newAccountName != null && newAccountName.isNotEmpty) {
                      setState(() {
                        _isLoading = true;
                      });
                      print("*********************************$newAccountName");
                      await DBProvider.db
                          .renameAccountAndRecords(account, newAccountName);
                      await dashboardProvider.updateDashboard();
                      await accountsProvider.refresh();
                      setState(() {
                        _isLoading = false;
                      });
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.edit),
                  ),
                ),
                if (accountsProvider.realaccounts.length > 1)
                  GestureDetector(
                    onTap: () async {
                      var value = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Account Delete'),
                            content: const Text(
                                'This will delete the Account and all its transaction. Please confirm.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      if (value ?? false) {
                        setState(() {
                          _isLoading = true;
                        });
                        await DBProvider.db.deleteAccountAndRecords(account);
                        await dashboardProvider.updateDashboard();
                        await accountsProvider.refresh();
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.delete),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
