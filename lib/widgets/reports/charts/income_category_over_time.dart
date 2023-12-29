import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/charts/category_line_chart.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data_grouped.dart';
import 'package:expense_manager/widgets/reports/charts/date_filter.dart';
import 'package:expense_manager/widgets/reports/charts/empty_chart.dart';
import 'package:expense_manager/widgets/reports/charts/multiselect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeCategoryOverTime extends StatefulWidget {
  const IncomeCategoryOverTime({super.key});

  @override
  IncomeCategoryOverTimeState createState() => IncomeCategoryOverTimeState();
}

class IncomeCategoryOverTimeState extends State<IncomeCategoryOverTime> {
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
    List<String> allCategories = categoryProvider.incomeCategories
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
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 290,
                  child: MultiCheckboxDropdown(
                    setStateFunc: setCategories,
                    dropdownValues: allCategories,
                    selectedValues: categoriesSelected,
                    emptyText: 'Select Income Category',
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<Map<String, List<GroupedChartData>>>(
            future: getIncomeByCategoryLineChartData(
                fromDate: fromDate,
                toDate: toDate,
                categories: categoriesSelected),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, List<GroupedChartData>>> snapshot) {
              Widget widget;
              if (snapshot.hasData) {
                Map<String, List<GroupedChartData>> data = snapshot.data!;
                if (data.keys.isEmpty) {
                  widget = const EmptyChart();
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
