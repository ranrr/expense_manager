import 'package:expense_manager/data/accounts_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/util/confirm_alert.dart';
import 'package:expense_manager/widgets/util/input_alert.dart';
import 'package:expense_manager/widgets/util/settings_loader.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageAccounts extends StatelessWidget {
  const ManageAccounts({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 10),
      children: const [
        AccountsSettingsInfoText(),
        AddAccountButtonRow(),
        AccountsListWithActions(),
      ],
    );
  }
}

class AccountsSettingsInfoText extends StatelessWidget {
  const AccountsSettingsInfoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 0, 0, 20),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Account delete will delete transactions too."),
          Text("Account rename will rename transactions too."),
        ],
      ),
    );
  }
}

class AddAccountButtonRow extends StatelessWidget {
  const AddAccountButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    //watch - because the widget should be rebuilt for loader
    var accountsProvider = context.watch<Accounts>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (accountsProvider.loading) const SettingsLoader(),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 35, 10),
          child: AddAccountButton(),
        ),
      ],
    );
  }
}

class AddAccountButton extends StatelessWidget {
  const AddAccountButton({super.key});

  @override
  Widget build(BuildContext context) {
    var accountsProvider = context.read<Accounts>();
    return ElevatedButton(
      onPressed: () async {
        var newAccountName = await showDialog<String?>(
          context: context,
          builder: (BuildContext context) {
            return const AddAccountAlert();
          },
        );
        if (newAccountName != null && newAccountName.isNotEmpty) {
          var message = await accountsProvider.addNewAccount(newAccountName);
          showSnackBar(message);
        }
      },
      child: const Text("Add Account"),
    );
  }
}

class AddAccountAlert extends StatelessWidget {
  const AddAccountAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return const InputAlertDialog(
      header: accountAddHeader,
      message: accountAddMessage,
    );
  }
}

class AccountsListWithActions extends StatelessWidget {
  const AccountsListWithActions({super.key});

  @override
  Widget build(BuildContext context) {
    //watch - because, the accounts list must be refreshed
    var accountsProvider = context.watch<Accounts>();
    List<String> allAccounts = accountsProvider.realaccounts;
    String activeAccount = accountsProvider.accountSelected;
    return ListView.builder(
      shrinkWrap: true,
      itemCount: allAccounts.length,
      itemBuilder: (BuildContext context, int index) {
        String account = allAccounts[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          child: Card(
            child: ListTile(
              leading:
                  AccontTitle(account: account, activeAccount: activeAccount),
              trailing: AccountActions(account: account),
            ),
          ),
        );
      },
    );
  }
}

class AccontTitle extends StatelessWidget {
  const AccontTitle({
    super.key,
    required this.account,
    required this.activeAccount,
  });

  final String account;
  final String activeAccount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          account,
          style: const TextStyle(fontSize: 16),
        ),
        // check mark icon for the active account
        if (account == activeAccount)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.check_circle),
          )
      ],
    );
  }
}

class AccountActions extends StatelessWidget {
  const AccountActions({super.key, required this.account});

  final String account;

  @override
  Widget build(BuildContext context) {
    var accountsProvider = context.read<Accounts>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RenameAccountAction(account: account),
        //if there is only 1 account - delete button is not visible
        if (accountsProvider.realaccounts.length > 1)
          DeleteAccountAction(account: account),
      ],
    );
  }
}

class RenameAccountAction extends StatelessWidget {
  const RenameAccountAction({super.key, required this.account});

  final String account;

  @override
  Widget build(BuildContext context) {
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.read<Accounts>();
    return GestureDetector(
      onTap: () async {
        var newAccountName = await showDialog<String?>(
          context: context,
          builder: (BuildContext context) {
            return RenameAccountAlert(account: account);
          },
        );
        if (newAccountName != null &&
            newAccountName != account &&
            newAccountName.isNotEmpty) {
          var message =
              await accountsProvider.renameAccount(account, newAccountName);
          await dashboardProvider.updateDashboard();
          showSnackBar(message);
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.edit),
      ),
    );
  }
}

class RenameAccountAlert extends StatelessWidget {
  const RenameAccountAlert({required this.account, super.key});

  final String account;

  @override
  Widget build(BuildContext context) {
    final accController = TextEditingController();
    accController.text = account;
    return InputAlertDialog(
      header: accountRenameHeader,
      message: accountRenameMessage,
      initialValue: account,
    );
  }
}

class DeleteAccountAction extends StatelessWidget {
  const DeleteAccountAction({super.key, required this.account});

  final String account;

  @override
  Widget build(BuildContext context) {
    var dashboardProvider = context.read<DashboardData>();
    var accountsProvider = context.read<Accounts>();
    String activeAccount = accountsProvider.accountSelected;
    return GestureDetector(
      onTap: () async {
        if (account == activeAccount) {
          showSnackBar("Cannot delete active account.");
        } else {
          var value = await showDialog<bool?>(
            context: context,
            builder: (BuildContext context) {
              return const DeleteAccountAlert();
            },
          );
          if (value ?? false) {
            var message = await accountsProvider.deleteAccount(account);
            await dashboardProvider.updateDashboard();
            showSnackBar(message);
          }
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.delete),
      ),
    );
  }
}

class DeleteAccountAlert extends StatelessWidget {
  const DeleteAccountAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConfirmAlertDialog(
        header: accountDeleteHeader, message: accountDeleteMessage);
  }
}
