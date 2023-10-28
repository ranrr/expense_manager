import 'package:expense_manager/data/period_report_provider.dart';
import 'package:expense_manager/widgets/reports/periodreports/day_period_report.dart';
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
          child: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              DayPeriodReport(),
              Center(child: Text("tab2")),
              Center(child: Text("tab3")),
              Center(child: Text("tab4")),
            ],
          ),
        ),
      ),
    );
  }
}
