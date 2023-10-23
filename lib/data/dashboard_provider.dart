import 'dart:math';

import 'package:expense_manager/model/period.dart';
import 'package:expense_manager/model/records_summary.dart';
import 'package:flutter/material.dart';

class DashboardData with ChangeNotifier {
  late int balance;
  late RecordsSummary today;
  late RecordsSummary week;
  late RecordsSummary month;
  late RecordsSummary year;

  RecordsSummary getDashboardSummary(int i) {
    switch (i) {
      case 0:
        return today;
      case 1:
        return week;
      case 2:
        return month;
      case 3:
        return year;
      default:
        throw IndexError;
    }
  }

  DashboardData.init() {
    updateDashboard();
  }

  updateDashboard() {
    _updateDashboardData();
    notifyListeners();
  }

  _updateDashboardData() {
    var random = Random();
    balance = random.nextInt(50000);
    today = RecordsSummary(
      totalIncome: random.nextInt(800),
      totalExpense: random.nextInt(800),
      period: Period.today,
    );
    week = RecordsSummary(
      totalIncome: random.nextInt(2000),
      totalExpense: random.nextInt(2000),
      period: Period.week,
    );
    month = RecordsSummary(
      totalIncome: random.nextInt(30000),
      totalExpense: random.nextInt(30000),
      period: Period.month,
    );
    year = RecordsSummary(
      totalIncome: random.nextInt(300000),
      totalExpense: random.nextInt(300000),
      period: Period.year,
    );
  }
}
