import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartBuilder extends StatelessWidget {
  const LineChartBuilder({
    super.key,
    required this.data,
    required this.xLegend,
    required this.yLegend,
  });
  final List<ChartData> data;
  final String xLegend;
  final String yLegend;

  @override
  Widget build(BuildContext context) {
    double chartHeight = getColumnChartHeight(data.length);
    return SizedBox(
      height: chartHeight,
      child: SfCartesianChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          primaryXAxis: CategoryAxis(
            title: AxisTitle(text: xLegend),
            labelRotation: -35,
          ),
          primaryYAxis: NumericAxis(
            title: AxisTitle(text: yLegend),
            labelAlignment: LabelAlignment.end,
            anchorRangeToVisiblePoints: true,
          ),
          series: <ChartSeries>[
            LineSeries<ChartData, String>(
              dataSource: data,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              name: '',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                labelAlignment: ChartDataLabelAlignment.auto,
              ),
            ),
          ]),
    );
  }
}
