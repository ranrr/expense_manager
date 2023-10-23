import 'package:expense_manager/data/add_record_provider.dart';
import 'package:expense_manager/widgets/record_entry/date_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordTypeAndDate extends StatelessWidget {
  const RecordTypeAndDate({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var recordProvider = context.watch<RecordProvider>();

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ToggleButtons(
          borderRadius: BorderRadius.circular(10),
          onPressed: (int index) {
            recordProvider.setRecordType(index);
          },
          isSelected: recordProvider.typeSelected,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text(
                "Expense",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Text(
                "Income",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
          child: ElevatedButton(
            onPressed: () async {
              DateTime? selected = await showDatePicker(
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2025),
              );
              var date = selected ?? recordProvider.date;
              recordProvider.setDate(date);
            },
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              minimumSize: const Size(100, 50),
            ),
            child: DateText(
              date: recordProvider.date,
            ),
          ),
        )
      ],
    );
  }
}
