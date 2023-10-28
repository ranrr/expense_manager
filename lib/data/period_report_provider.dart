import 'package:flutter/material.dart';

import '../utils/constants.dart';

class PeriodReportProvider with ChangeNotifier {
  DateTime selectedDay;
  DateTime selectedWeek;
  DateTime selectedMonth;
  DateTime selectedYear;

  Period? updatedPeriod;

  PeriodReportProvider.init(DateTime date)
      : selectedDay = date,
        selectedWeek = date,
        selectedMonth = date,
        selectedYear = date;

  updateSelectedDay(DateTime date) {
    selectedDay = date;
    updatedPeriod = Period.today;
    notifyListeners();
  }

  updateSelectedWeek(DateTime date) {
    selectedWeek = date;
    updatedPeriod = Period.week;
    notifyListeners();
  }

  updateSelectedMonth(DateTime date) {
    selectedMonth = date;
    updatedPeriod = Period.month;
    notifyListeners();
  }

  updateSelectedYear(DateTime date) {
    selectedYear = date;
    updatedPeriod = Period.year;
    notifyListeners();
  }
}
