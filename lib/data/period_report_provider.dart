import 'package:flutter/material.dart';

import '../utils/constants.dart';

class PeriodReportProvider with ChangeNotifier {
  DateTime _selectedDay;
  DateTime _selectedWeek;
  DateTime _selectedMonth;
  DateTime _selectedYear;

  DateTime get selectedDay => _selectedDay;

  DateTime get selectedWeek => _selectedWeek;

  DateTime get selectedMonth => _selectedMonth;

  DateTime get selectedYear => _selectedYear;

  Period? updatedPeriod;

  PeriodReportProvider.init(DateTime date)
      : _selectedDay = date,
        _selectedWeek = date,
        _selectedMonth = date,
        _selectedYear = date;

  decreaseDay() {
    _selectedDay = DateUtils.addDaysToDate(selectedDay, -1);
    notifyListeners();
  }

  increaseDay() {
    _selectedDay = DateUtils.addDaysToDate(selectedDay, 1);
    notifyListeners();
  }

  updateSelectedDay(DateTime date) {
    _selectedDay = date;
    notifyListeners();
  }

  decreaseWeek() {
    _selectedWeek = DateUtils.addDaysToDate(selectedWeek, -7);
    notifyListeners();
  }

  increaseWeek() {
    _selectedWeek = DateUtils.addDaysToDate(selectedWeek, 7);
    notifyListeners();
  }

  updateSelectedWeek(DateTime date) {
    _selectedWeek = date;
    updatedPeriod = Period.week;
    notifyListeners();
  }

  updateSelectedMonth(DateTime date) {
    _selectedMonth = date;
    updatedPeriod = Period.month;
    notifyListeners();
  }

  updateSelectedYear(DateTime date) {
    _selectedYear = date;
    updatedPeriod = Period.year;
    notifyListeners();
  }
}
