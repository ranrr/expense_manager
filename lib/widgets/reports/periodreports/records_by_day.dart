import 'package:expense_manager/model/record_day_grouped.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/periodreports/records_day_grouped.dart';
import 'package:flutter/material.dart';

class RecordsSummarizedByDateFutureBuilder extends StatelessWidget {
  const RecordsSummarizedByDateFutureBuilder({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<DateTime, RecordDateGrouped>>(
      future: getExpIncByDay(startDate, endDate),
      builder: (BuildContext context,
          AsyncSnapshot<Map<DateTime, RecordDateGrouped>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          var result = snapshot.data!;
          if (result.keys.isEmpty) {
            widget = const Padding(
              padding: EdgeInsets.fromLTRB(28, 10, 0, 10),
              child: Text(
                "No Transactions",
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            widget = RecordsTable(data: result);
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
