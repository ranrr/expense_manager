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
    List<String> allAccounts = accountsProvider.realaccounts;
    String activeAccount = accountsProvider.accountSelected;
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Account delete will delete transactions too."),
              Text("Account rename will rename transactions too."),
            ],
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 35, 10),
              child: ElevatedButton(
                onPressed: () async {
                  var newAccountName = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      final accController = TextEditingController();
                      return AlertDialog(
                        title: const Text('Add Account'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Enter Account Name'),
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
                            onPressed: () => Navigator.pop(
                                context, accController.text.trim()),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  if (newAccountName != null && newAccountName.isNotEmpty) {
                    if (allAccounts.contains(newAccountName)) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: Text("Account name already exists."),
                            ),
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(30),
                            shape: StadiumBorder(),
                            duration: Duration(milliseconds: 2000),
                          ),
                        );
                      }
                    } else {
                      setState(() {
                        _isLoading = true;
                      });
                      await DBProvider.db.addNewAccount(newAccountName);
                      await accountsProvider.refresh();
                    }
                    setState(() {
                      _isLoading = false;
                    });
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(
                            child: Text("Account added."),
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(30),
                          shape: StadiumBorder(),
                          duration: Duration(milliseconds: 2000),
                        ),
                      );
                    }
                  }
                },
                child: const Text("Add Account"),
              ),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: allAccounts.length,
          itemBuilder: (BuildContext context, int index) {
            String account = allAccounts[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: Card(
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        account,
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (account == activeAccount)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.check_circle),
                        )
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                                    onPressed: () => Navigator.pop(
                                        context, accController.text.trim()),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                          if (newAccountName != null &&
                              newAccountName != account &&
                              newAccountName.isNotEmpty) {
                            setState(() {
                              _isLoading = true;
                            });
                            await DBProvider.db.renameAccountAndRecords(
                                account, newAccountName);
                            await dashboardProvider.updateDashboard();
                            await accountsProvider.refresh();
                            setState(() {
                              _isLoading = false;
                            });
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Center(
                                    child: Text("Account renamed."),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(30),
                                  shape: StadiumBorder(),
                                  duration: Duration(milliseconds: 2000),
                                ),
                              );
                            }
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
                            if (account == activeAccount) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Center(
                                      child:
                                          Text("Cannot delete active account."),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(30),
                                    shape: StadiumBorder(),
                                    duration: Duration(milliseconds: 2000),
                                  ),
                                );
                              }
                            } else {
                              var value = await showDialog<bool>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Account Delete'),
                                    content: const Text(
                                        'This will delete the Account and all its transactions. Please confirm.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
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
                                await DBProvider.db
                                    .deleteAccountAndRecords(account);
                                await dashboardProvider.updateDashboard();
                                await accountsProvider.refresh();
                                setState(() {
                                  _isLoading = false;
                                });
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Center(
                                        child: Text("Account deleted."),
                                      ),
                                      behavior: SnackBarBehavior.floating,
                                      margin: EdgeInsets.all(30),
                                      shape: StadiumBorder(),
                                      duration: Duration(milliseconds: 2000),
                                    ),
                                  );
                                }
                              }
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
              ),
            );
          },
        ),
      ],
    );
  }
}
