import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class CategoryGroupedRecords extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final RecordType recordType;
  const CategoryGroupedRecords(
      {required this.startDate,
      required this.endDate,
      required this.recordType,
      super.key});

  @override
  Widget build(BuildContext context) {
    var func = (recordType.name == RecordType.expense.name)
        ? DBProvider.db.getCatSubcatGroupedExpences
        : DBProvider.db.getCatSubcatGroupedIncomes;
    return FutureBuilder<List<Map<String, Object?>>>(
      future: func(startDate, endDate),
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, Object?>>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          var data = snapshot.data!;
          widget = ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                margin: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                child: Text(
                  data[index].toString(),
                ),
              );
            },
          );
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
