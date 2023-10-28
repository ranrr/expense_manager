import 'package:expense_manager/utils/constants.dart';

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
