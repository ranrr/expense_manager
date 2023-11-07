import 'package:flutter/material.dart';

import 'custom_period_filter.dart';

class PeriodReportProvider with ChangeNotifier {
  DateTime _selectedDay;
  DateTime _selectedWeek;
  DateTime _selectedMonth;
  DateTime _selectedYear;
  CustomPeriodFilter _customPeriodFilter;

  DateTime get selectedDay => _selectedDay;

  DateTime get selectedWeek => _selectedWeek;

  DateTime get selectedMonth => _selectedMonth;

  DateTime get selectedYear => _selectedYear;

  CustomPeriodFilter get customPeriodFilter => _customPeriodFilter;

  PeriodReportProvider.init(DateTime date)
      : _selectedDay = date,
        _selectedWeek = date,
        _selectedMonth = DateTime(date.year, date.month, 1),
        _selectedYear = DateTime(date.year, 1, 1),
        _customPeriodFilter = CustomPeriodFilter.init();

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
    notifyListeners();
  }

  decreaseMonth() {
    _selectedMonth = DateUtils.addMonthsToMonthDate(_selectedMonth, -1);
    notifyListeners();
  }

  increaseMonth() {
    _selectedMonth = DateUtils.addMonthsToMonthDate(_selectedMonth, 1);
    notifyListeners();
  }

  updateSelectedMonth(DateTime date) {
    _selectedMonth = DateTime(date.year, date.month, 1);
    notifyListeners();
  }

  decreaseYear() {
    _selectedYear = DateTime(_selectedYear.year - 1, 01, 01);
    notifyListeners();
  }

  increaseYear() {
    _selectedYear = DateTime(_selectedYear.year + 1, 01, 01);
    notifyListeners();
  }

  updateSelectedYear(DateTime date) {
    _selectedYear = DateTime(date.year, 01, 01);
    notifyListeners();
  }

  // updateCustomPeriod(DateTime startDate, DateTime endDate) {
  //   _customPeriodFilter.startDate = startDate;
  //   _customPeriodFilter.endDate = endDate;
  //   notifyListeners();
  // }

  updateCustomPeriod(DateTime startDate, DateTime endDate,
      {bool? recordsonly, String? category, String? subCategory}) {
    _customPeriodFilter.startDate = startDate;
    _customPeriodFilter.endDate = endDate;
    _customPeriodFilter.recordsOnly = recordsonly ?? false;
    _customPeriodFilter.category = category;
    _customPeriodFilter.subCategory = subCategory;
    notifyListeners();
  }
}
