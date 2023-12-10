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
        child: ExpansionPanelList.radio(
          elevation: 3,
          //TODO check frame rate
          // animationDuration: const Duration(milliseconds: 600),
          children: [
            ExpansionPanelRadio(
              value: "accounts",
              canTapOnHeader: true,
              headerBuilder: (_, isExpanded) {
                return const PanelHeader(
                  header: "Accounts",
                );
              },
              body: const ManageAccounts(),
            ),
            ExpansionPanelRadio(
              value: "expences",
              canTapOnHeader: true,
              headerBuilder: (_, isExpanded) {
                return const PanelHeader(
                  header: "Expense Categories",
                );
              },
              body: const ExpenseCategoriesSettings(),
            ),
            ExpansionPanelRadio(
              value: "incomes",
              canTapOnHeader: true,
              headerBuilder: (_, isExpanded) {
                return const PanelHeader(
                  header: "Income Categories",
                );
              },
              body: const IncomeCategoriesSettings(),
            ),
            ExpansionPanelRadio(
              value: "exclusion",
              canTapOnHeader: true,
              headerBuilder: (_, isExpanded) {
                return const PanelHeader(
                  header: "Chart Exclusion Categories",
                );
              },
              body: const ExclusionCategories(),
            ),
            ExpansionPanelRadio(
              value: "autofills",
              canTapOnHeader: true,
              headerBuilder: (_, isExpanded) {
                return const PanelHeader(
                  header: "Auto-Fill Templates",
                );
              },
              body: const AutoFillSettings(),
            ),
            ExpansionPanelRadio(
              value: "backup",
              canTapOnHeader: true,
              headerBuilder: (_, isExpanded) {
                return const PanelHeader(
                  header: "Backup",
                );
              },
              body: const BackupPanel(),
            ),
            ExpansionPanelRadio(
              value: "restore",
              canTapOnHeader: true,
              headerBuilder: (_, isExpanded) {
                return const PanelHeader(
                  header: "Restore",
                );
              },
              body: const RestorePanel(),
            ),
            ExpansionPanelRadio(
              value: "reset",
              canTapOnHeader: true,
              headerBuilder: (_, isExpanded) {
                return const PanelHeader(
                  header: "Reset App",
                );
              },
              body: const ResetPanel(),
            ),
            ExpansionPanelRadio(
              value: "load",
              canTapOnHeader: true,
              headerBuilder: (_, isExpanded) {
                return const PanelHeader(
                  header: "Load Sample Data",
                );
              },
              body: const LoadDataPanel(),
            ),
          ],
        ),
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
