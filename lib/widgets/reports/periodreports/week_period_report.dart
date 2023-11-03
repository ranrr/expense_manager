import 'package:expense_manager/data/period_report_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/widgets/reports/periodreports/catgrouped_records.dart';
import 'package:expense_manager/widgets/reports/periodreports/income_expense_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekPeriodReport extends StatelessWidget {
  final DateTime selectedWeek;
  const WeekPeriodReport({required this.selectedWeek, super.key});

  @override
  Widget build(BuildContext context) {
    var dates = getStartEndDateOfWeek(selectedWeek);
    DateTime startDate = dates.$1;
    DateTime endDate = dates.$2;
    return Column(
      children: [
        WeekPeriodNavigator(selectedWeek: selectedWeek),
        Expanded(
          child: ListView(
            children: [
              CategoryGroupedRecords(
                  startDate: startDate,
                  endDate: endDate,
                  recordType: RecordType.expense),
              CategoryGroupedRecords(
                  startDate: startDate,
                  endDate: endDate,
                  recordType: RecordType.income),
            ],
          ),
        ),
      ],
    );
  }
}

class WeekPeriodNavigator extends StatelessWidget {
  final DateTime selectedWeek;
  const WeekPeriodNavigator({required this.selectedWeek, super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<PeriodReportProvider>();
    var dates = getStartEndDateOfWeek(selectedWeek);
    DateTime startDate = dates.$1;
    DateTime endDate = dates.$2;
    return Card(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              provider.decreaseWeek();
            },
            child: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 50,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final DateTime? selectedDate = await showDatePicker(
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                context: context,
                initialDate: selectedWeek,
                firstDate: DateTime(2010),
                lastDate: DateTime(2025),
              );
              if (selectedDate != null) {
                provider.updateSelectedWeek(selectedDate);
              }
            },
            child: Column(
              children: [
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Text(
                          getWeekRangeAsText(selectedWeek),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Icon(
                          Icons.calendar_view_week,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                FutureBuilder<(int, int)>(
                  future: DBProvider.db
                      .getTotalIncomeAndExpense(startDate, endDate),
                  builder: (BuildContext context,
                      AsyncSnapshot<(int, int)> snapshot) {
                    Widget widget;
                    if (snapshot.hasData) {
                      var result = snapshot.data!;
                      widget = IncomeExpenseRow(
                          income: result.$1, expense: result.$2);
                    } else if (snapshot.hasError) {
                      widget = Container();
                    } else {
                      widget = Container();
                    }
                    return widget;
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              provider.increaseWeek();
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
