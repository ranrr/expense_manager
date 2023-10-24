import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/model/record.dart';
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
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text("Auto-Fill"),
          ),
        ),
        if (recordProvider.action == RecordAction.delete)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: ElevatedButton(
              onPressed: () {
                recordProvider.deleteRecord();
              },
              child: const Text("Delete"),
            ),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
          child: ElevatedButton(
            onPressed: () {
              bool success;
              List<String> errors;
              (success, errors) = recordProvider.addRecord();
              if (success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(child: Text("Added successfully.")),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(30),
                    shape: StadiumBorder(),
                  ),
                );
                dashboardData.updateDashboard();
                Navigator.pop(context);
              } else {
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
            },
            child: const Text("Save"),
          ),
        ),
      ],
    );
  }
}
