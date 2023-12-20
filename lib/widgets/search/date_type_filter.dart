import 'package:expense_manager/data/search_provider.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateAndTypeFilter extends StatelessWidget {
  const DateAndTypeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SearchDates(),
          ],
        ),
        Padding(padding: EdgeInsets.all(5)),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SearchTypeToggle(),
          ],
        ),
      ],
    );
  }
}

class SearchTypeToggle extends StatelessWidget {
  const SearchTypeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SearchProvider>();
    return ToggleButtons(
      borderRadius: BorderRadius.circular(4),
      onPressed: (int index) {
        provider.setRecordType(index);
      },
      isSelected: provider.typeSelected,
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 11, right: 12),
          child: Text(
            "All",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 11, right: 12),
          child: Text(
            "Expense",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 11, right: 12),
          child: Text(
            "Income",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

class SearchDates extends StatelessWidget {
  const SearchDates({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SearchProvider>();
    String buttonText;
    if (provider.fromDate == null) {
      buttonText = 'Select Date Range';
    } else {
      buttonText =
          "${getDateTextYY(provider.fromDate!)} - ${getDateTextYY(provider.toDate!)}";
    }

    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        )),
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
                              final DateTime? rangeEndDate = args.value.endDate;

                              if (rangeStartDate != null &&
                                  rangeEndDate != null) {
                                provider.setSearchDates(
                                    rangeStartDate, rangeEndDate);
                                Navigator.pop(context);
                              }
                            }
                          },
                          selectionMode: DateRangePickerSelectionMode.range),
                    ),
                  )
                ],
              );
            },
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(buttonText, style: const TextStyle(fontSize: 16)),
            const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Icon(Icons.filter_alt_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
