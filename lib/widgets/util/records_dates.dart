import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/widgets/util/record_list.dart';
import 'package:flutter/material.dart';
import 'package:expense_manager/model/record.dart';

//List of records for given dates and category
class RecordsForDates extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final String? category;
  final String? subCategory;
  const RecordsForDates({
    required this.startDate,
    required this.endDate,
    this.category,
    this.subCategory,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Record>>(
      future: DBProvider.db
          .getAllRecordsBetweenDate(startDate, endDate, category, subCategory),
      builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          List<Record> records = snapshot.data!;
          if (records.isEmpty) {
            widget = const Padding(
              padding: EdgeInsets.fromLTRB(28, 10, 0, 10),
              child: Text(
                "No Transactions",
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            widget = Expanded(child: RecordsList(records: records));
          }
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
