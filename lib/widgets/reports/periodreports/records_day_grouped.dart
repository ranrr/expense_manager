import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class RecordsGroupedByDay extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  const RecordsGroupedByDay(
      {required this.startDate, required this.endDate, super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, Object?>>>(
      future: DBProvider.db.getExpenseByDay(startDate, endDate),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          var result = snapshot.data!;
          widget = RecordsTable(data: result);
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

class RecordsTable extends StatelessWidget {
  final List<Map<String, Object?>> data;
  const RecordsTable({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
              print('row $index pressed');
            },
          );
        },
      ),
    );
  }
}
