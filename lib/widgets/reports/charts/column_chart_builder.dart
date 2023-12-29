import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnChartBuilder extends StatelessWidget {
  const ColumnChartBuilder({super.key, required this.data});
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
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.auto,
            ),
            name: '',
          )
        ],
      ),
    );
  }
}
