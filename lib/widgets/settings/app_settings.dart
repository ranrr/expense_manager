import 'package:expense_manager/widgets/settings/accounts.dart';
import 'package:expense_manager/widgets/settings/backup.dart';
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
          animationDuration: const Duration(milliseconds: 600),
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

class LoadDataPanel extends StatelessWidget {
  const LoadDataPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Load sample data."),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: LoadData(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResetPanel extends StatelessWidget {
  const ResetPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Reset app database."),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: ResetAppData(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RestorePanel extends StatelessWidget {
  const RestorePanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Restore app database from backup."),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Restore(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BackupPanel extends StatelessWidget {
  const BackupPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: const Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Backup app database."),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.all(8),
                child: Backup(),
              ),
            ],
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
