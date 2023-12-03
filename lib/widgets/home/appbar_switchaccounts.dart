import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppbarSwitchAccountsIcon extends StatelessWidget {
  const AppbarSwitchAccountsIcon({super.key});

  @override
  Widget build(BuildContext context) {
    Accounts accountsProvider = context.watch<Accounts>();
    DashboardData dashboardData = context.read<DashboardData>();
    var chartProvider = context.read<RefreshCharts>();
    List<String> accounts = accountsProvider.accounts;
    String accountSelected = accountsProvider.accountSelected;
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
              return PopupMenuItem(
                onTap: () async {
                  await accountsProvider.updateAccountSelected(accounts[index]);
                  await dashboardData.updateDashboard();
                  await chartProvider.refresh();
                  showSnackBar("Switched to account - ${accounts[index]}");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      accounts[index],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (accountSelected == accounts[index])
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Icon(Icons.check_circle),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
