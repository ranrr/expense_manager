import 'package:expense_manager/data/period_report_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/record_entry/record_edit.dart';
import 'package:expense_manager/widgets/reports/periodreports/income_expense_row.dart';
import 'package:expense_manager/widgets/util/record_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DayPeriodReport extends StatelessWidget {
  final DateTime selectedDay;
  const DayPeriodReport({required this.selectedDay, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TxnRecord>>(
      future: DBProvider.db.getAllRecordsByDate(selectedDay),
      builder: (BuildContext context, AsyncSnapshot<List<TxnRecord>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          List<TxnRecord> records = snapshot.data!;
          widget = DayPeriodRecords(day: selectedDay, records: records);
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
  final List<TxnRecord> records;
  final DateTime day;

  const DayPeriodRecords({
    super.key,
    required this.day,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    int expense = getExpenseOfRecords(records);
    int income = getIncomeOfRecords(records);
    return Column(
      children: [
        DayPeriodNavigator(
          selectedDay: day,
          income: income,
          expense: expense,
        ),
        if (records.isEmpty)
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("No Transactions"),
          ),
        Expanded(
          child: ListView.builder(
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
        ),
      ],
    );
  }
}

class DayPeriodNavigator extends StatelessWidget {
  final DateTime selectedDay;
  final int income;
  final int expense;
  const DayPeriodNavigator(
      {required this.selectedDay,
      required this.income,
      required this.expense,
      super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<PeriodReportProvider>();
    return Card(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //left arraw - decrease day
          GestureDetector(
            onTap: () {
              provider.decreaseDay();
            },
            child: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 50,
            ),
          ),
          //center section - column of day row and income, expense row
          GestureDetector(
            onTap: () async {
              final DateTime? selectedDate = await showDatePicker(
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                context: context,
                initialDate: selectedDay,
                firstDate: DateTime(2010),
                lastDate: DateTime(2025),
              );
              if (selectedDate != null) {
                provider.updateSelectedDay(selectedDate);
              }
            },
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          getDateText(selectedDay),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Icon(
                          Icons.calendar_view_day,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  IncomeExpenseRow(income: income, expense: expense),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              provider.increaseDay();
            },
            child: const Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
