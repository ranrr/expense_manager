import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/charts/category_line_chart.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data_line.dart';
import 'package:expense_manager/widgets/reports/charts/date_filter.dart';
import 'package:expense_manager/widgets/reports/charts/multiselect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseCategoryOverTime extends StatefulWidget {
  const ExpenseCategoryOverTime({super.key});

  @override
  ExpenseCategoryOverTimeState createState() => ExpenseCategoryOverTimeState();
}

class ExpenseCategoryOverTimeState extends State<ExpenseCategoryOverTime> {
  late DateTime fromDate;
  late DateTime toDate;
  List<String> categoriesSelected = [];

  @override
  void initState() {
    var dates = getRunningThreeMonthsDates();
    fromDate = dates.$1;
    toDate = dates.$2;
    super.initState();
  }

  void setDates(DateTime rangeStartDate, DateTime rangeEndDate) {
    setState(() {
      fromDate = rangeStartDate;
      toDate = rangeEndDate;
    });
  }

  void setCategories(List<String> categories) {
    setState(() {
      categoriesSelected = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.watch<RefreshCharts>();
    Categories categoryProvider = context.read<Categories>();
    List<String> allCategories = categoryProvider.expenceCategories
        .map((e) => e.category)
        .toSet()
        .toList();
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          DateFilter(fromDate: fromDate, toDate: toDate, setDates: setDates),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 275,
                  child: MultiCheckboxDropdown(
                    setStateFunc: setCategories,
                    dropdownValues: allCategories,
                    selectedValues: categoriesSelected,
                    emptyText: 'Select Expense Category',
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<Map<String, List<LineChartData>>>(
            future: getExpenseByCategoryLineChartData(
                fromDate: fromDate,
                toDate: toDate,
                categories: categoriesSelected),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, List<LineChartData>>> snapshot) {
              Widget widget;
              if (snapshot.hasData) {
                Map<String, List<LineChartData>> data = snapshot.data!;
                if (data.keys.isEmpty) {
                  widget = const Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
                    child: Center(
                      child: Text(
                        "No Transactions",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                } else {
                  widget = CategoryLineChart(data: data);
                }
              } else if (snapshot.hasError) {
                widget = Container();
              } else {
                widget = Container();
              }
              return widget;
            },
          ),
        ],
      ),
    );
  }
}
