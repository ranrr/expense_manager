import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class PeriodReportProvider with ChangeNotifier {
  DateTime _selectedDay;
  DateTime _selectedWeek;
  DateTime _selectedMonth;
  DateTime _selectedYear;

  DateTime _customStartDate;
  DateTime _customEndDate;
  String? _customCategory;
  String? _customSubCategory;

  DateTime get selectedDay => _selectedDay;

  DateTime get selectedWeek => _selectedWeek;

  DateTime get selectedMonth => _selectedMonth;

  DateTime get selectedYear => _selectedYear;

  Period? updatedPeriod;

  PeriodReportProvider.init(DateTime date)
      : _selectedDay = date,
        _selectedWeek = date,
        _selectedMonth = DateTime(date.year, date.month, 1),
        _selectedYear = DateTime(date.year, 1, 1),
        _customStartDate = date,
        _customEndDate = date;

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
    updatedPeriod = Period.month;
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
    updatedPeriod = Period.year;
    notifyListeners();
  }
}
