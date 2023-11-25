import 'package:expense_manager/utils/constants.dart';

class DashboardGridSummary {
  final int totalIncome;
  final int totalExpense;
  final Period period;
  DashboardGridSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.period,
  });
}
