import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/data/refresh_period_report.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.read<RecordProvider>();
    DashboardData dashboardData = context.read<DashboardData>();
    RefreshPeriodReport periodReportProvider =
        context.read<RefreshPeriodReport>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (recordProvider.action != RecordAction.edit)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Auto-Fill"),
            ),
          ),
        if (recordProvider.action == RecordAction.edit)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: ElevatedButton(
              onPressed: () async {
                await recordProvider.deleteRecord(recordProvider.id!);
                await dashboardData.updateDashboard(); // update home dashboard
                // Refresh app to update period report
                await periodReportProvider.refresh();
                showSnackBar("Deleted successfully.");
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text("Delete"),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
          child: ElevatedButton(
            onPressed: () async {
              bool success;
              List<String> errors;
              (success, errors) = await recordProvider.addRecord();
              await dashboardData.updateDashboard(); // update home dashboard
              // Refresh app to update period report
              await periodReportProvider.refresh();
              if (success && context.mounted) {
                showSnackBar("Saved successfully.");
                Navigator.pop(context);
              } else {
                if (context.mounted) {
                  String error = "Please enter valid ${errors.join(", ")}";
                  showSnackBar(error);
                }
              }
            },
            child: const Text("Save"),
          ),
        ),
      ],
    );
  }
}
