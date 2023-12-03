import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data.dart';
import 'package:expense_manager/widgets/reports/charts/date_filter.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MonthlyExpenseChart extends StatefulWidget {
  const MonthlyExpenseChart({super.key});

  @override
  MonthlyExpenseChartState createState() => MonthlyExpenseChartState();
}

class MonthlyExpenseChartState extends State<MonthlyExpenseChart> {
  late DateTime fromDate;
  late DateTime toDate;
  // late TooltipBehavior _tooltip;

  @override
  void initState() {
    var dates = getRunningThreeMonthsDates();
    fromDate = dates.$1;
    toDate = dates.$2;
    // _tooltip = TooltipBehavior(enable: true);
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
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ListView(
        shrinkWrap: true,
        children: [
          DateFilter(fromDate: fromDate, toDate: toDate, setDates: setDates),
          FutureBuilder<List<ChartData>>(
            future: DBProvider.db.totalExpenseGroupedByMonth(fromDate, toDate),
            builder: (BuildContext context,
                AsyncSnapshot<List<ChartData>> snapshot) {
              Widget widget;
              if (snapshot.hasData) {
                List<ChartData> data = snapshot.data!;
                widget = _Chart(data: data);
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

class _Chart extends StatelessWidget {
  const _Chart({required this.data});
  final List<ChartData> data;

  @override
  Widget build(BuildContext context) {
    var tooltip = TooltipBehavior(enable: true);
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      tooltipBehavior: tooltip,
      series: <ChartSeries<ChartData, String>>[
        BarSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          name: '',
          // gradient: LinearGradient(
          //     colors: [Colors.lightBlueAccent, Colors.redAccent])
          // color: Color.fromRGBO(8, 142, 255, 1),
        )
      ],
    );
  }
}
