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
          snapshot.data!;
          widget = Container();
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
