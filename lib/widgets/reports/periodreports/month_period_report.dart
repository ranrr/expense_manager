import 'package:expense_manager/data/period_report_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/widgets/reports/periodreports/catgrouped_records.dart';
import 'package:expense_manager/widgets/reports/periodreports/income_expense_row.dart';
import 'package:expense_manager/widgets/reports/periodreports/records_day_grouped.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthPeriodReport extends StatelessWidget {
  final DateTime selectedMonth;
  const MonthPeriodReport({required this.selectedMonth, super.key});

  @override
  Widget build(BuildContext context) {
    var dates = getStartAndLastDayOfMonth(selectedMonth);
    DateTime startDate = dates.$1;
    DateTime endDate = dates.$2;
    return Column(
      children: [
        _MonthPeriodNavigator(selectedMonth: selectedMonth),
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

class _MonthPeriodNavigator extends StatelessWidget {
  final DateTime selectedMonth;
  const _MonthPeriodNavigator({required this.selectedMonth, super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<PeriodReportProvider>();
    var dates = getStartAndLastDayOfMonth(selectedMonth);
    DateTime startDate = dates.$1;
    DateTime endDate = dates.$2;
    return Card(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              provider.decreaseMonth();
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
                initialDate: selectedMonth,
                firstDate: DateTime(2010),
                lastDate: DateTime(2025),
              );
              if (selectedDate != null) {
                provider.updateSelectedMonth(selectedDate);
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
                          getMonthRangeAsText(selectedMonth),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Icon(
                          Icons.calendar_view_month,
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
              provider.increaseMonth();
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
