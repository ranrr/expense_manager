import 'package:expense_manager/data/period_report_provider.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecordsTable extends StatelessWidget {
  final List<Map<String, Object?>> data;
  const RecordsTable({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var provider = context.read<PeriodReportProvider>();
    return DataTable(
      showCheckboxColumn: false,
      columns: const <DataColumn>[
        DataColumn(
          label: Expanded(
            child: Center(
              child: Text(
                'Date',
                // style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Expense',
              // style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        DataColumn(
          label: Expanded(
            child: Text(
              'Income',
              // style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ],
      rows: List<DataRow>.generate(
        data.length,
        (int index) {
          var row = data[index];
          var date = row['date']!.toString().substring(0, 10);
          var expense = row['type'] == RecordType.expense.name
              ? row['balance'].toString()
              : '0';
          var income = row['type'] == RecordType.income.name
              ? row['balance'].toString()
              : '0';
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(date)),
              DataCell(Text(expense)),
              DataCell(Text(income)),
            ],
            onSelectChanged: (newValue) {
              DateTime d = DateTime.parse(date);
              provider.updateSelectedDay(d);
              DefaultTabController.of(context).animateTo(Period.today.indx);
            },
          );
        },
      ),
    );
  }
}
