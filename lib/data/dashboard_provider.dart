import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/model/dashboard_grid_summary.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/foundation.dart';

class DashboardData with ChangeNotifier {
  int? _balance = 0;
  DashboardGridSummary? _today;
  DashboardGridSummary? _week;
  DashboardGridSummary? _month;
  DashboardGridSummary? _year;
  List<TxnRecord>? _records;

  int get balance {
    return _balance ?? 0;
  }

  List<TxnRecord> get records {
    return _records ?? [];
  }

  DashboardGridSummary getDashboardSummary(Period period) {
    switch (period) {
      case Period.today:
        return _today ??
            DashboardGridSummary(
                totalIncome: 0, totalExpense: 0, period: Period.today);
      case Period.week:
        return _week ??
            DashboardGridSummary(
                totalIncome: 0, totalExpense: 0, period: Period.week);
      case Period.month:
        return _month ??
            DashboardGridSummary(
                totalIncome: 0, totalExpense: 0, period: Period.month);
      case Period.year:
        return _year ??
            DashboardGridSummary(
                totalIncome: 0, totalExpense: 0, period: Period.year);
      default:
        throw IndexError;
    }
  }

  DashboardData.init() {
    updateDashboard();
  }

  updateDashboard() async {
    _today = await DBProvider.db.getTodaysData();
    _week = await DBProvider.db.getCurrentWeekData();
    _month = await DBProvider.db.getCurrentMonthData();
    _year = await DBProvider.db.getCurrentYearData();
    _balance = await DBProvider.db.getCurrentBalance();
    _records = await DBProvider.db.getRecentRecords(10);
    notifyListeners();
  }
}
