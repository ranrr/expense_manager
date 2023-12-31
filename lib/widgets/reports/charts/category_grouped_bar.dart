import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data_grouped.dart';
import 'package:expense_manager/widgets/reports/charts/date_filter.dart';
import 'package:expense_manager/widgets/reports/charts/empty_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryGroupedBar extends StatefulWidget {
  const CategoryGroupedBar({super.key});

  @override
  CategoryGroupedBarState createState() => CategoryGroupedBarState();
}

class CategoryGroupedBarState extends State<CategoryGroupedBar> {
  late DateTime fromDate;
  late DateTime toDate;

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

  @override
  Widget build(BuildContext context) {
    context.watch<RefreshCharts>();

    Categories categoryProvider = context.read<Categories>();
    List<String> allCategories = categoryProvider.expenceCategories
        .map((e) => e.category)
        .toSet()
        .toList();
    double nMonths = toDate.difference(fromDate).inDays / 30;
    double boxSize = 400 + (280 * nMonths);
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          DateFilter(fromDate: fromDate, toDate: toDate, setDates: setDates),
          const SizedBox(height: 8),
          FutureBuilder<Map<String, List<GroupedChartData>>>(
            future: getCategoryGroupedBarData(
                fromDate: fromDate, toDate: toDate, categories: allCategories),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, List<GroupedChartData>>> snapshot) {
              Widget widget;
              if (snapshot.hasData) {
                Map<String, List<GroupedChartData>> data = snapshot.data!;
                if (data.isEmpty) {
                  widget = const EmptyChart();
                } else {
                  widget = SizedBox(
                      height: boxSize, child: GroupedBarChart(data: data));
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

class GroupedBarChart extends StatelessWidget {
  const GroupedBarChart({super.key, required this.data});

  final Map<String, List<GroupedChartData>> data;

  @override
  Widget build(BuildContext context) {
    List<String> month = data.keys.toList();
    return SfCartesianChart(
      title: const ChartTitle(text: 'Expense Category Grouped'),
      legend: const Legend(isVisible: true),
      series: List.generate(month.length, (index) {
        String title = month[index];
        List<GroupedChartData> seriesData = data[month[index]]!;
        return BarSeries<GroupedChartData, String>(
          dataSource: seriesData,
          xValueMapper: (GroupedChartData lcd, _) => lcd.category,
          yValueMapper: (GroupedChartData lcd, _) => lcd.amt,
          dataLabelMapper: (GroupedChartData lcd, _) =>
              '${lcd.str} - ${lcd.amt}',
          name: title,
          sortFieldValueMapper: (GroupedChartData lcd, _) => lcd.str,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.auto,
          ),
        );
      }),
      primaryXAxis: const CategoryAxis(),
      primaryYAxis: const NumericAxis(
        title: AxisTitle(text: 'Expense'),
      ),
    );
  }
}
