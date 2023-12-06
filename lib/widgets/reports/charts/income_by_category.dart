import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data.dart';
import 'package:expense_manager/widgets/reports/charts/date_filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomeByCategory extends StatefulWidget {
  const IncomeByCategory({super.key});

  @override
  IncomeByCategoryState createState() => IncomeByCategoryState();
}

class IncomeByCategoryState extends State<IncomeByCategory> {
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
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: [
          DateFilter(fromDate: fromDate, toDate: toDate, setDates: setDates),
          FutureBuilder<List<ChartData>>(
            future: DBProvider.db.incomeGroupedByCategory(fromDate, toDate),
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
    double chartHeight = getColumnChartHeight(data.length);
    return SizedBox(
      height: chartHeight,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(),
        primaryYAxis: getNumericAxis(),
        tooltipBehavior: tooltip,
        series: <ColumnSeries<ChartData, String>>[
          ColumnSeries<ChartData, String>(
            dataSource: data,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            name: '',
          )
        ],
      ),
    );
  }
}
