import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/widgets/reports/charts/Line_chart_builder.dart';
import 'package:expense_manager/widgets/reports/charts/bar_chart_builder.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data.dart';
import 'package:expense_manager/widgets/reports/charts/date_filter.dart';
import 'package:expense_manager/widgets/reports/charts/empty_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MonthlyIncomeChart extends StatefulWidget {
  const MonthlyIncomeChart({super.key});

  @override
  MonthlyIncomeChartState createState() => MonthlyIncomeChartState();
}

class MonthlyIncomeChartState extends State<MonthlyIncomeChart> {
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    var dates = getRunningSixMonthsDates();
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
          const SizedBox(height: 8),
          FutureBuilder<List<ChartData>>(
            future: DBProvider.db.totalIncomeGroupedByMonth(fromDate, toDate),
            builder: (BuildContext context,
                AsyncSnapshot<List<ChartData>> snapshot) {
              Widget widget;
              if (snapshot.hasData) {
                List<ChartData> data = snapshot.data!;
                if (data.isEmpty) {
                  widget = const EmptyChart();
                } else {
                  widget = Column(
                    children: [
                      LineChartBuilder(
                          data: data, xLegend: 'Month', yLegend: 'Income'),
                      BarChartBuilder(data: data),
                    ],
                  );
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
