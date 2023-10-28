import 'package:expense_manager/data/period_report_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/record.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/widgets/record_entry/record_edit.dart';
import 'package:expense_manager/widgets/util/record_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DayPeriodReport extends StatelessWidget {
  const DayPeriodReport({super.key});

  @override
  Widget build(BuildContext context) {
    PeriodReportProvider provider = context.watch<PeriodReportProvider>();
    return FutureBuilder<List<Record>>(
      future: DBProvider.db.getAllRecordsByDate(provider.selectedDay),
      builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          List<Record> records = snapshot.data!;
          widget = DayPeriodRecords(records: records);
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

class DayPeriodRecords extends StatelessWidget {
  const DayPeriodRecords({
    super.key,
    required this.records,
  });

  final List<Record> records;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        getDateAndNavRow(context),
        ListView.builder(
          shrinkWrap: true,
          itemCount: records.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditRecord(id: records[index].id!),
                  ),
                );
              },
              child: RecordTile(record: records[index]),
            );
          },
        ),
      ],
    );
  }
}

Card getDateAndNavRow(BuildContext context) {
  return Card(
    margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        navigatePreviousPeriod(),
        getActivityPeriodText(context),
        navigateNextPeriod(),
      ],
    ),
  );
}

GestureDetector navigateNextPeriod() {
  return GestureDetector(
    onTap: () {
      // _switchTab(ActivityTime.day, date.add(const Duration(days: 1)));
    },
    child: const Icon(
      Icons.keyboard_arrow_right_rounded,
      size: 50,
    ),
  );
}

Expanded getActivityPeriodText(BuildContext context) {
  return Expanded(
    flex: 2,
    child: Center(
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.space,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              getDateText(DateTime.now()),
              style: const TextStyle(fontSize: 18),
            ),
          ),
          getDatePicker(context),
        ],
      ),
    ),
  );
}

GestureDetector navigatePreviousPeriod() {
  return GestureDetector(
    onTap: () {
      // _switchTab(ActivityTime.day, date.subtract(const Duration(days: 1)));
    },
    child: const Icon(
      Icons.keyboard_arrow_left_rounded,
      size: 50,
    ),
  );
}

getDatePicker(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
    child: GestureDetector(
      onTap: () async {
        DateTime? selectedDate = await _selectDate(context);
        if (selectedDate != null) {
          // _switchTab(ActivityTime.day, selectedDate);
        }
      },
      child: const Icon(
        Icons.calendar_view_day,
        size: 30,
      ),
    ),
  );
}

Future<DateTime?> _selectDate(BuildContext context) async {
  final DateTime? selectedDate = await selectDate(context, DateTime.now());
  return selectedDate;
}

Future<DateTime?> selectDate(BuildContext context, DateTime initialDate) async {
  final DateTime? selected = await showDatePicker(
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    context: context,
    initialDate: initialDate,
    firstDate: DateTime(2010),
    lastDate: DateTime(2025),
  );
  return selected;
}
