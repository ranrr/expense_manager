import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/model/record.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    RecordProvider recordProvider = context.watch<RecordProvider>();

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
              recordProvider.addRecord();
            },
            child: const Text("Save"),
          ),
        ),
      ],
    );
  }
}
