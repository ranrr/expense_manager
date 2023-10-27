import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.watch<RecordProvider>();
    DashboardData dashboardData = context.watch<DashboardData>();

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
                await dashboardData.updateDashboard();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Center(child: Text("Deleted successfully.")),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.all(30),
                      shape: StadiumBorder(),
                    ),
                  );
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
              await dashboardData.updateDashboard();
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(child: Text("Saved successfully.")),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(30),
                    shape: StadiumBorder(),
                  ),
                );
                Navigator.pop(context);
              } else {
                if (context.mounted) {
                  String error = "Please enter valid ${errors.join(", ")}";
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Center(child: Text(error)),
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(30),
                      shape: const StadiumBorder(),
                    ),
                  );
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
