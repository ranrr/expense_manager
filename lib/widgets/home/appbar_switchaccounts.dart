import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarSwitchAccountsIcon extends StatelessWidget {
  const AppbarSwitchAccountsIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Accounts accountsProvider = context.watch<Accounts>();
    DashboardData dashboardData = context.read<DashboardData>();
    List<String> accounts = accountsProvider.accounts;
    String accountSelected = accountsProvider.accountSelected;
    //TODO test max account name characters
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: PopupMenuButton(
        elevation: 20,
        tooltip: "Switch Account",
        icon: const Icon(
          Icons.switch_account,
          size: 25,
        ),
        itemBuilder: (context) {
          return List.generate(
            accounts.length,
            (index) {
              if (accountSelected == accounts[index]) {
                return PopupMenuItem(
                  onTap: () async {
                    await accountsProvider
                        .updateAccountSelected(accounts[index]);
                    await dashboardData.updateDashboard();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(
                            child: Text(
                                "Switched to account - ${accounts[index]}"),
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(30),
                          shape: const StadiumBorder(),
                          duration: const Duration(milliseconds: 2000),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        accounts[index],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(Icons.check_circle),
                    ],
                  ),
                );
              } else {
                return PopupMenuItem(
                  value: accounts[index],
                  onTap: () async {
                    await accountsProvider
                        .updateAccountSelected(accounts[index]);
                    await dashboardData.updateDashboard();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(
                            child: Text(
                                "Switched to account - ${accounts[index]}"),
                          ),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(30),
                          shape: const StadiumBorder(),
                          duration: const Duration(milliseconds: 2000),
                        ),
                      );
                    }
                  },
                  child: Text(accounts[index]),
                );
              }
            },
          );
        },
      ),
    );
  }
}
