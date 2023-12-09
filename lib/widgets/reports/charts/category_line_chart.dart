import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data_line.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryLineChart extends StatelessWidget {
  const CategoryLineChart({super.key, required this.data});
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
