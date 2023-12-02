import 'package:expense_manager/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateFilter extends StatelessWidget {
  const DateFilter(
      {super.key,
      required this.fromDate,
      required this.toDate,
      required this.setDates});

  final DateTime fromDate;
  final DateTime toDate;
  final Function setDates;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () async {
            await showDialog<String?>(
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
                                  setDates(rangeStartDate, rangeEndDate);
                                  Navigator.pop(context);
                                }
                              }
                            },
                            selectionMode: DateRangePickerSelectionMode.range),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Text("${getDateTextYY(fromDate)}  -  ${getDateTextYY(toDate)}",
              style: const TextStyle(fontSize: 16)),
        ),
        const Icon(Icons.filter_alt_outlined),
      ],
    );
  }
}
