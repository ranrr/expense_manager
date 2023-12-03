import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/data/refresh_period_report.dart';
import 'package:expense_manager/model/autofill.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/util/confirm_alert.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.read<RecordProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (recordProvider.action != RecordAction.edit)
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: AutoFillButton(),
          ),
        if (recordProvider.action == RecordAction.edit)
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: DeleteButton(),
          ),
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
          child: SaveButton(),
        ),
      ],
    );
  }
}

class SaveButton extends StatelessWidget {
  const SaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.read<RecordProvider>();
    DashboardData dashboardData = context.read<DashboardData>();
    RefreshPeriodReport periodReportProvider =
        context.read<RefreshPeriodReport>();
    return ElevatedButton(
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
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key});

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.read<RecordProvider>();
    DashboardData dashboardData = context.read<DashboardData>();
    RefreshPeriodReport periodReportProvider =
        context.read<RefreshPeriodReport>();
    return ElevatedButton(
      onPressed: () async {
        var value = await showDialog<bool?>(
          context: context,
          builder: (BuildContext context) {
            return const ConfirmAlertDialog(
                header: recordDeleteHeader, message: recordDeleteMessage);
          },
        );
        if (value ?? false) {
          await recordProvider.deleteRecord(recordProvider.id!);
          await dashboardData.updateDashboard(); // update home dashboard
          // Refresh app to update period report
          await periodReportProvider.refresh();
          showSnackBar("Deleted successfully.");
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: const Text("Delete"),
    );
  }
}

class AutoFillButton extends StatelessWidget {
  const AutoFillButton({super.key});

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.read<RecordProvider>();
    return FutureBuilder<List<AutoFill>>(
      future: getAllAutoFillRecords(),
      builder: (BuildContext context, AsyncSnapshot<List<AutoFill>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          List<AutoFill> records = snapshot.data!;
          widget = ElevatedButton(
            onPressed: () async {
              await showDialog<void>(
                context: context,
                builder: (BuildContext context) {
                  if (records.isEmpty) {
                    return const NoAutoFillRecords();
                  } else {
                    return AutoFillRecordsList(
                      records: records,
                      recordProvider: recordProvider,
                    );
                  }
                },
              );
            },
            child: const Text("Auto-Fill"),
          );
        } else if (snapshot.hasError) {
          widget = Container();
        } else {
          widget = Container();
        }
        return widget;
      },
    );
  }
}

class AutoFillRecordsList extends StatelessWidget {
  const AutoFillRecordsList({
    super.key,
    required this.records,
    required this.recordProvider,
  });

  final List<AutoFill> records;
  final RecordProvider recordProvider;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Select Auto-Fill'),
      children: records
          .map(
            (autoFillrecord) => SimpleDialogOption(
              onPressed: () async {
                await recordProvider.copyWithAutoFill(autoFillrecord);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text(autoFillrecord.name),
            ),
          )
          .toList(),
    );
  }
}

class NoAutoFillRecords extends StatelessWidget {
  const NoAutoFillRecords({super.key});

  @override
  Widget build(BuildContext context) {
    return const SimpleDialog(
      title: Text('Select Auto-Fill'),
      children: [
        SimpleDialogOption(
          child: Center(child: Text('No Auto-Fill Templates')),
        )
      ],
    );
  }
}
