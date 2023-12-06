import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data.dart';
import 'package:expense_manager/widgets/reports/charts/date_filter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class IncomeCategoryDoughnutChart extends StatefulWidget {
  const IncomeCategoryDoughnutChart({super.key});

  @override
  IncomeCategoryDoughnutChartState createState() =>
      IncomeCategoryDoughnutChartState();
}

class IncomeCategoryDoughnutChartState
    extends State<IncomeCategoryDoughnutChart> {
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
      margin: const EdgeInsets.only(right: 20),
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
    return SfCircularChart(
      series: <DoughnutSeries<ChartData, String>>[
        DoughnutSeries<ChartData, String>(
          enableTooltip: true,
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          dataLabelMapper: (ChartData data, _) => '${data.x} \n ${data.y}',
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.inside,
            useSeriesColor: true,
          ),
        ),
      ],
    );
  }
}
