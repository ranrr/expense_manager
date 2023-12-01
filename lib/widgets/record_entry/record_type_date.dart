import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordTypeAndDate extends StatelessWidget {
  const RecordTypeAndDate({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        RecordTypeToggle(),
        RecordDateSelection(),
      ],
    );
  }
}

class RecordDateSelection extends StatelessWidget {
  const RecordDateSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RecordProvider, DateTime>(
      selector: (context, provider) => provider.date,
      builder: (context, date, _) {
        var recordProvider = context.read<RecordProvider>();
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 0, 5),
          child: ElevatedButton(
            onPressed: () async {
              DateTime? selectedDate = await showDatePicker(
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2025),
              );
              if (selectedDate != null) {
                recordProvider.setDate(selectedDate);
              }
            },
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              minimumSize: const Size(100, 50),
            ),
            child: Text(
              getDateText(recordProvider.date),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}

class RecordTypeToggle extends StatelessWidget {
  const RecordTypeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<RecordProvider, String>(
      selector: (context, provider) => provider.recordType,
      builder: (context, recType, _) {
        var recordProvider = context.read<RecordProvider>();
        return ToggleButtons(
          borderRadius: BorderRadius.circular(10),
          onPressed: (int index) {
            recordProvider.setRecordType(index);
          },
          isSelected: recordProvider.typeSelected,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Expense",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
              child: Text(
                "Income",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }
}
