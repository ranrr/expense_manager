import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/record.dart';
import 'package:expense_manager/model/records_summary.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/foundation.dart';

class DashboardData with ChangeNotifier {
  int? _balance = 0;
  RecordsSummary? _today;
  RecordsSummary? _week;
  RecordsSummary? _month;
  RecordsSummary? _year;
  List<Record>? _records;

  int get balance {
    return _balance ?? 0;
  }

  List<Record> get records {
    return _records ?? [];
  }

  // RecordsSummary getDashboardSummary1(int i) {
  //   switch (i) {
  //     case 0:
  //       return _today ??
  //           RecordsSummary(
  //               totalIncome: 0, totalExpense: 0, period: Period.today);
  //     case 1:
  //       return _week ??
  //           RecordsSummary(
  //               totalIncome: 0, totalExpense: 0, period: Period.week);
  //     case 2:
  //       return _month ??
  //           RecordsSummary(
  //               totalIncome: 0, totalExpense: 0, period: Period.month);
  //     case 3:
  //       return _year ??
  //           RecordsSummary(
  //               totalIncome: 0, totalExpense: 0, period: Period.year);
  //     default:
  //       throw IndexError;
  //   }
  // }

  RecordsSummary getDashboardSummary(Period period) {
    switch (period) {
      case Period.today:
        return _today ??
            RecordsSummary(
                totalIncome: 0, totalExpense: 0, period: Period.today);
      case Period.week:
        return _week ??
            RecordsSummary(
                totalIncome: 0, totalExpense: 0, period: Period.week);
      case Period.month:
        return _month ??
            RecordsSummary(
                totalIncome: 0, totalExpense: 0, period: Period.month);
      case Period.year:
        return _year ??
            RecordsSummary(
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
