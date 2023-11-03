import 'package:expense_manager/data/period_report_provider.dart';
import 'package:expense_manager/widgets/reports/periodreports/day_period_report.dart';
import 'package:expense_manager/widgets/reports/periodreports/month_period_report.dart';
import 'package:expense_manager/widgets/reports/periodreports/week_period_report.dart';
import 'package:expense_manager/widgets/reports/periodreports/year_period_report.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PeriodReport extends StatelessWidget {
  final int initialIndex;
  const PeriodReport({required this.initialIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: initialIndex,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Expense & Income"),
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(text: 'Today'),
              Tab(text: 'Week'),
              Tab(text: 'Month'),
              Tab(text: 'Year'),
            ],
          ),
        ),
        body: ChangeNotifierProvider(
          create: (context) =>
              PeriodReportProvider.init(DateUtils.dateOnly(DateTime.now())),
          child: TabBarView(
            // physics: const NeverScrollableScrollPhysics(),
            children: [
              Selector<PeriodReportProvider, DateTime>(
                selector: (context, provider) => provider.selectedDay,
                builder: (context, day, _) {
                  return DayPeriodReport(selectedDay: day);
                },
              ),
              Selector<PeriodReportProvider, DateTime>(
                selector: (context, provider) => provider.selectedWeek,
                builder: (context, week, _) {
                  return WeekPeriodReport(selectedWeek: week);
                },
              ),
              Selector<PeriodReportProvider, DateTime>(
                selector: (context, provider) => provider.selectedMonth,
                builder: (context, month, _) {
                  return MonthPeriodReport(selectedMonth: month);
                },
              ),
              Selector<PeriodReportProvider, DateTime>(
                selector: (context, provider) => provider.selectedYear,
                builder: (context, year, _) {
                  return YearPeriodReport(selectedYear: year);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
