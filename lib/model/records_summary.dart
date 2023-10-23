import 'package:expense_manager/model/period.dart';

class RecordsSummary {
  final int totalIncome;
  final int totalExpense;
  final Period period;
  RecordsSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.period,
  });
}
