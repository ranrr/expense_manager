import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data.dart';
import 'package:expense_manager/widgets/reports/charts/date_filter.dart';
import 'package:expense_manager/widgets/reports/charts/empty_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpenseByCategoryChart extends StatefulWidget {
  const ExpenseByCategoryChart({super.key});

  @override
  ExpenseByCategoryChartState createState() => ExpenseByCategoryChartState();
}

class ExpenseByCategoryChartState extends State<ExpenseByCategoryChart> {
  late DateTime fromDate;
  late DateTime toDate;

  bool isDrilledChart = false;
  String? drilledCategory;

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

  Widget getDefaultChart(List<ChartData> data) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: getNumericAxis(),
      tooltipBehavior: TooltipBehavior(enable: false),
      series: <ChartSeries<ChartData, String>>[
        BarSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.auto,
          ),
          name: '',
          onPointTap: (pointTapArgs) {
            if (pointTapArgs.pointIndex != null) {
              setState(() {
                isDrilledChart = true;
                drilledCategory = data[pointTapArgs.pointIndex!].x;
              });
            }
          },
        ),
      ],
    );
  }

  Widget getDrilledChart(List<ChartData> data) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: getNumericAxis(),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries<ChartData, String>>[
        BarSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.auto,
          ),
          name: '',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<RefreshCharts>();
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          // date selection in for the chart
          DateFilter(fromDate: fromDate, toDate: toDate, setDates: setDates),
          const SizedBox(height: 8),
          //default chart with parent category details
          Visibility(
            visible: !isDrilledChart,
            child: FutureBuilder<List<ChartData>>(
              future: getExpenseByCategoryChartData(
                  fromDate: fromDate, toDate: toDate),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ChartData>> snapshot) {
                Widget widget;
                if (snapshot.hasData) {
                  List<ChartData> data = snapshot.data!;
                  if (data.isEmpty) {
                    widget = const EmptyChart();
                  } else {
                    widget = SizedBox(
                        height: getBarChartHeight(data.length),
                        child: getDefaultChart(data));
                  }
                } else if (snapshot.hasError) {
                  widget = Container();
                } else {
                  widget = Container();
                }
                return widget;
              },
            ),
          ),
          //drilled down chart with sub-category details
          Visibility(
            visible: isDrilledChart,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        isDrilledChart = false;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(Icons.arrow_back),
                    )),
                FutureBuilder<List<ChartData>>(
                  future: getExpenseByCategoryChartData(
                      fromDate: fromDate,
                      toDate: toDate,
                      isDrilled: true,
                      category: drilledCategory),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ChartData>> snapshot) {
                    Widget widget;
                    if (snapshot.hasData) {
                      List<ChartData> data = snapshot.data!;
                      widget = SizedBox(
                          height: getBarChartHeight(data.length),
                          child: getDrilledChart(data));
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
          ),
        ],
      ),
    );
  }
}
