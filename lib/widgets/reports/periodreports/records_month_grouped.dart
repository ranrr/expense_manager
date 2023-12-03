import 'package:collection/collection.dart';
import 'package:expense_manager/data/period_report_provider.dart';
import 'package:expense_manager/model/record_day_grouped.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordsTableForYear extends StatelessWidget {
  final Map<DateTime, RecordDateGrouped> data;
  const RecordsTableForYear({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provider = context.read<PeriodReportProvider>();
    List<DateTime> keys = data.keys.sorted();
    return DataTable(
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Center(child: Text('Date')),
          ),
        ),
        DataColumn(
          label: Expanded(child: Text('Expense')),
        ),
        DataColumn(
          label: Expanded(child: Text('Income')),
        ),
      ],
      rows: List<DataRow>.generate(
        keys.length,
        (int index) {
          var row = data[keys[index]];
          var date = getMonthYearText(row!.date);
          var expense = formatNumber(row.expense);
          var income = formatNumber(row.income);
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(date)),
              DataCell(Text(expense)),
              DataCell(Text(income)),
            ],
            onSelectChanged: (newValue) {
              provider.updateSelectedMonth(row.date);
              DefaultTabController.of(context).animateTo(Period.month.indx);
            },
          );
        },
      ),
    );
  }
}
