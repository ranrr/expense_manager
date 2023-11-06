import 'package:expense_manager/model/record_day_grouped.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/periodreports/records_month_grouped.dart';
import 'package:flutter/material.dart';

class RecordsSummarizedByMonthFutureBuilder extends StatelessWidget {
  const RecordsSummarizedByMonthFutureBuilder({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<DateTime, RecordDateGrouped>>(
      future: getExpIncByMonth(startDate, endDate),
      builder: (BuildContext context,
          AsyncSnapshot<Map<DateTime, RecordDateGrouped>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          var result = snapshot.data!;
          widget = RecordsTableForYear(data: result);
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
