import 'package:expense_manager/data/period_report_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/record.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/record_entry/record_edit.dart';
import 'package:expense_manager/widgets/util/record_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeekPeriodReport extends StatelessWidget {
  final DateTime selectedWeek;
  const WeekPeriodReport({required this.selectedWeek, super.key});

  @override
  Widget build(BuildContext context) {
    var dates = getStartEndDateOfWeek(selectedWeek);
    DateTime startDate = dates.$1;
    DateTime endDate = dates.$2;
    return FutureBuilder<List<Record>>(
      future: DBProvider.db.getAllRecordsBetweenDate(startDate, endDate),
      builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          List<Record> records = snapshot.data!;
          widget = WeekPeriodRecords(records: records);
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

class WeekPeriodRecords extends StatelessWidget {
  final List<Record> records;

  const WeekPeriodRecords({
    super.key,
    required this.records,
  });

  @override
  Widget build(BuildContext context) {
    int expense = getExpenseOfRecords(records);
    int income = getIncomeOfRecords(records);
    print("income $income, expense $expense");
    return Column(
      children: [
        Selector<PeriodReportProvider, DateTime>(
          selector: (context, provider) => provider.selectedWeek,
          builder: (context, week, _) {
            return WeekPeriodNavigator(selectedWeek: week);
          },
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: records.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditRecord(id: records[index].id!),
                    ),
                  );
                },
                child: RecordTile(record: records[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class WeekPeriodNavigator extends StatelessWidget {
  final DateTime selectedWeek;
  const WeekPeriodNavigator({required this.selectedWeek, super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<PeriodReportProvider>();
    return Card(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              provider.decreaseWeek();
            },
            child: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 50,
            ),
          ),
          Center(
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.space,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    getWeekRangeAsText(selectedWeek),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? selectedDate = await showDatePicker(
                        initialEntryMode: DatePickerEntryMode.calendarOnly,
                        context: context,
                        initialDate: selectedWeek,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2025),
                      );
                      if (selectedDate != null) {
                        provider.updateSelectedWeek(selectedDate);
                      }
                    },
                    child: const Icon(
                      Icons.calendar_view_day,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              provider.increaseWeek();
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
