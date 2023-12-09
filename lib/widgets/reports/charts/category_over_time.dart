import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data_line.dart';
import 'package:expense_manager/widgets/reports/charts/date_filter.dart';
import 'package:expense_manager/widgets/reports/charts/multiselect.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryOverTime extends StatefulWidget {
  const CategoryOverTime({super.key});

  @override
  CategoryOverTimeState createState() => CategoryOverTimeState();
}

class CategoryOverTimeState extends State<CategoryOverTime> {
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
    List<String> allCategories =
        categoryProvider.categories.map((e) => e.category).toSet().toList();
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
                  width: 260,
                  child: MultiCheckboxDropdown(
                    setStateFunc: setCategories,
                    dropdownValues: allCategories,
                    selectedValues: categoriesSelected,
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
                  widget = _LineChart(data: data);
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

class _LineChart extends StatelessWidget {
  const _LineChart({required this.data});
  final Map<String, List<LineChartData>> data;

  @override
  Widget build(BuildContext context) {
    List<String> categories = data.keys.toList();
    double chartHeight = getColumnChartHeight(data.length);
    return SizedBox(
      height: chartHeight,
      child: SfCartesianChart(
        legend: const Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        primaryXAxis: CategoryAxis(
          title: AxisTitle(text: 'Month'),
          labelRotation: -35,
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(text: 'Category'),
          labelAlignment: LabelAlignment.end,
          anchorRangeToVisiblePoints: true,
        ),
        series: List<LineSeries<LineChartData, String>>.generate(
          categories.length,
          (index) {
            String title = categories[index];
            List<LineChartData> seriesData = data[categories[index]]!;
            return LineSeries<LineChartData, String>(
              dataSource: seriesData,
              xValueMapper: (LineChartData lcd, _) => lcd.str.toString(),
              yValueMapper: (LineChartData lcd, _) => lcd.amt,
              name: title,
            );
          },
        ),
      ),
    );
  }
}
