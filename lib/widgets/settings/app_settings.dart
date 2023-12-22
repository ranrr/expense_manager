import 'package:expense_manager/widgets/settings/accounts_settings.dart';
import 'package:expense_manager/widgets/settings/autofill_settings.dart';
import 'package:expense_manager/widgets/settings/backup.dart';
import 'package:expense_manager/widgets/settings/exclusion_categories.dart';
import 'package:expense_manager/widgets/settings/expense_categories_settings.dart';
import 'package:expense_manager/widgets/settings/income_categories_settings.dart';
import 'package:expense_manager/widgets/settings/load_data.dart';
import 'package:expense_manager/widgets/settings/reset.dart';
import 'package:expense_manager/widgets/settings/restore.dart';
import 'package:flutter/material.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: const [
            AccountsSettings(),
            ExpenseCategories(),
            IncomeCategories(),
            ChartExclusionCategories(),
            AutoFill(),
            Backup(),
            Restore(),
            Reset(),
            LoadData(),
          ],
        ),
      ),
    );
  }
}

class AccountsSettings extends StatelessWidget {
  const AccountsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Manage Accounts')),
                body: const ManageAccounts()),
          ),
        );
      },
      title: const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.manage_accounts),
          ),
          Text(
            'Accounts',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class ExpenseCategories extends StatelessWidget {
  const ExpenseCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar:
                    AppBar(title: const Text('Add / Edit Expense Categories')),
                body: const ExpenseCategoriesSettings()),
          ),
        );
      },
      title: const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.category_rounded),
          ),
          Text(
            'Expense Categories',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class IncomeCategories extends StatelessWidget {
  const IncomeCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar:
                    AppBar(title: const Text('Add / Edit Income Categories')),
                body: const IncomeCategoriesSettings()),
          ),
        );
      },
      title: const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.category_rounded),
          ),
          Text(
            'Income Categories',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class ChartExclusionCategories extends StatelessWidget {
  const ChartExclusionCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                appBar:
                    AppBar(title: const Text('Add / Edit Chart Exclusions')),
                body: const ExclusionCategories()),
          ),
        );
      },
      title: const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.remove_circle_rounded),
          ),
          Text(
            'Chart Exclusion Categories',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class AutoFill extends StatelessWidget {
  const AutoFill({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(Icons.close_sharp),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 300, child: AutoFillSettings())
              ],
            );
          },
        );
      },
      title: const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.autorenew_rounded),
          ),
          Text(
            'Auto-Fill Templates',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class Backup extends StatelessWidget {
  const Backup({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(Icons.save), //TODO check this icon
                      ),
                    ),
                  ],
                ),
                const SizedBox(child: BackupPanel())
              ],
            );
          },
        );
      },
      title: const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.save_alt),
          ),
          Text(
            'Backup',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class Restore extends StatelessWidget {
  const Restore({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(Icons.close_sharp),
                      ),
                    ),
                  ],
                ),
                const SizedBox(child: RestorePanel())
              ],
            );
          },
        );
      },
      title: const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.restore_outlined),
          ),
          Text(
            'Restore',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class Reset extends StatelessWidget {
  const Reset({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(Icons.close_sharp),
                      ),
                    ),
                  ],
                ),
                const SizedBox(child: ResetPanel())
              ],
            );
          },
        );
      },
      title: const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.reset_tv_rounded),
          ),
          Text(
            'Reset',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class LoadData extends StatelessWidget {
  const LoadData({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Icon(Icons.close_sharp),
                      ),
                    ),
                  ],
                ),
                const SizedBox(child: LoadDataPanel())
              ],
            );
          },
        );
      },
      title: const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: Icon(Icons.save_alt),
          ),
          Text(
            'Load Sample Data',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class PanelHeader extends StatelessWidget {
  final String header;
  const PanelHeader({
    required this.header,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Text(
        header,
        style: const TextStyle(fontSize: 20),
      ),
    );
  }
}
