import 'package:expense_manager/data/period_report_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/record_day_grouped.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/periodreports/catgrouped_records.dart';
import 'package:expense_manager/widgets/reports/periodreports/income_expense_row.dart';
import 'package:expense_manager/widgets/reports/periodreports/period_report_divider.dart';
import 'package:expense_manager/widgets/reports/periodreports/records_by_month.dart';
import 'package:expense_manager/widgets/reports/periodreports/records_month_grouped.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YearPeriodReport extends StatelessWidget {
  final DateTime selectedYear;
  const YearPeriodReport({required this.selectedYear, super.key});

  @override
  Widget build(BuildContext context) {
    var dates = getStartAndLastDayOfYear(selectedYear);
    DateTime startDate = dates.$1;
    DateTime endDate = dates.$2;
    return Column(
      children: [
        _YearPeriodNavigator(selectedYear: selectedYear),
        Expanded(
          child: ListView(
            children: [
              const PeriodReportDivider(text: "Expense"),
              CategoryGroupedRecords(
                  startDate: startDate,
                  endDate: endDate,
                  recordType: RecordType.expense),
              const Divider(height: 20, thickness: 1),
              const PeriodReportDivider(text: "Income"),
              CategoryGroupedRecords(
                  startDate: startDate,
                  endDate: endDate,
                  recordType: RecordType.income),
              const Divider(height: 20, thickness: 1),
              const PeriodReportDivider(text: "By Month"),
              RecordsSummarizedByMonthFutureBuilder(
                  startDate: startDate, endDate: endDate),
              const Divider(height: 20, thickness: 1),
            ],
          ),
        ),
      ],
    );
  }
}

class _YearPeriodNavigator extends StatelessWidget {
  final DateTime selectedYear;
  const _YearPeriodNavigator({required this.selectedYear});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<PeriodReportProvider>();
    var dates = getStartAndLastDayOfYear(selectedYear);
    DateTime startDate = dates.$1;
    DateTime endDate = dates.$2;
    return Card(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              provider.decreaseYear();
            },
            child: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 50,
            ),
          ),
          Column(
            children: [
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Text(
                        getYearRangeAsText(selectedYear),
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<(int, int)>(
                future:
                    DBProvider.db.getTotalIncomeAndExpense(startDate, endDate),
                builder:
                    (BuildContext context, AsyncSnapshot<(int, int)> snapshot) {
                  Widget widget;
                  if (snapshot.hasData) {
                    var result = snapshot.data!;
                    widget =
                        IncomeExpenseRow(income: result.$1, expense: result.$2);
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
          GestureDetector(
            onTap: () {
              provider.increaseYear();
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
