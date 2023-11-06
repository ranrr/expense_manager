// ignore_for_file: must_be_immutable

import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/widgets/reports/periodreports/catgrouped_records.dart';
import 'package:expense_manager/widgets/reports/periodreports/period_report_divider.dart';
import 'package:expense_manager/widgets/reports/periodreports/records_by_day.dart';
import 'package:expense_manager/widgets/reports/periodreports/records_by_month.dart';
import 'package:expense_manager/widgets/util/records_dates.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomPeriodReport extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;
  final bool recordsOnly;
  String? category;
  String? subCategory;

  //if start date and end date is not provided, default period is (current day) to (current day-6)
  CustomPeriodReport(
      {DateTime? startDate,
      DateTime? endDate,
      bool? recordsOnly,
      this.category,
      this.subCategory,
      super.key})
      : startDate = startDate ??
            DateUtils.addDaysToDate(DateUtils.dateOnly(DateTime.now()), -6),
        endDate = endDate ?? (DateUtils.dateOnly(DateTime.now())),
        recordsOnly = recordsOnly ?? false;

  @override
  State<CustomPeriodReport> createState() => _CustomPeriodReportState();
}

class _CustomPeriodReportState extends State<CustomPeriodReport> {
  late DateTime startDate;
  late DateTime endDate;

  @override
  void initState() {
    startDate = widget.startDate;
    endDate = widget.endDate;
    super.initState();
  }

  void updatePeriod(DateTime fromDate, DateTime toDate) {
    print("updating period to $fromDate $toDate");
    setState(() {
      startDate = fromDate;
      endDate = toDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool recordsOnly = widget.recordsOnly;

    return Column(
      children: [
        _CustomPeriodNavigator(
            fromDate: startDate, toDate: endDate, updatePeriod: updatePeriod),
        if (recordsOnly)
          _CustomPeriodRecordsOnlyScene(
            startDate: startDate,
            endDate: endDate,
            category: widget.category,
            subCategory: widget.subCategory,
          )
        else
          _CustomPeriodNormalScene(startDate: startDate, endDate: endDate)
      ],
    );
  }
}

class _CustomPeriodRecordsOnlyScene extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  String? category;
  String? subCategory;
  _CustomPeriodRecordsOnlyScene(
      {required this.startDate,
      required this.endDate,
      this.category,
      this.subCategory});

  @override
  Widget build(BuildContext context) {
    return RecordsForDates(startDate: startDate, endDate: endDate);
  }
}

class _CustomPeriodNormalScene extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  const _CustomPeriodNormalScene(
      {required this.startDate, required this.endDate});

  @override
  Widget build(BuildContext context) {
    Duration difference = endDate.difference(startDate);
    int noOfDays = difference.inDays;
    return Expanded(
      child: ListView(
        children: [
          const PeriodReportDivider(text: "Expense"),
          CategoryGroupedRecords(
            startDate: startDate,
            endDate: endDate,
            recordType: RecordType.expense,
          ),
          const Divider(height: 20, thickness: 1),
          const PeriodReportDivider(text: "Income"),
          CategoryGroupedRecords(
            startDate: startDate,
            endDate: endDate,
            recordType: RecordType.income,
          ),
          const Divider(height: 20, thickness: 1),
          const PeriodReportDivider(text: "By Date"),
          if (noOfDays < 30)
            RecordsSummarizedByDateFutureBuilder(
                startDate: startDate, endDate: endDate)
          else
            RecordsSummarizedByMonthFutureBuilder(
                startDate: startDate, endDate: endDate),
          const Divider(height: 20, thickness: 1),
        ],
      ),
    );
  }
}

class _CustomPeriodNavigator extends StatelessWidget {
  final DateTime fromDate;
  final DateTime toDate;
  final Function updatePeriod;
  const _CustomPeriodNavigator(
      {required this.fromDate,
      required this.toDate,
      required this.updatePeriod});

  @override
  Widget build(BuildContext context) {
    var startDateDisplay = getDateText(fromDate);
    var endDateDisplay = getDateText(toDate);
    return Card(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              var value = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('Select Date Range'),
                    children: <Widget>[
                      SimpleDialogOption(
                        onPressed: () {
                          Navigator.pop(context, "data1");
                        },
                        child: SizedBox(
                          height: 300,
                          width: 300,
                          child: SfDateRangePicker(
                              onSelectionChanged:
                                  (DateRangePickerSelectionChangedArgs args) {
                                if (args.value is PickerDateRange) {
                                  final DateTime? rangeStartDate =
                                      args.value.startDate;
                                  final DateTime? rangeEndDate =
                                      args.value.endDate;

                                  if (rangeStartDate != null &&
                                      rangeEndDate != null) {
                                    print("$rangeStartDate $rangeEndDate");
                                    updatePeriod(rangeStartDate, rangeEndDate);
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              selectionMode:
                                  DateRangePickerSelectionMode.range),
                        ),
                      )
                    ],
                  );
                },
              );
            },
            child: Column(
              children: [
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            "$startDateDisplay To $endDateDisplay",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Icon(
                          Icons.edit_calendar,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
