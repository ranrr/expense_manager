import 'package:intl/intl.dart';

DateTime getTodaysDate() {
  var now = DateTime.now();
  return getDate(now);
}

DateTime getDate(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}

String getDateForDisplay(DateTime date) {
  return '${date.year} - ${date.month} - ${date.day}';
}

String getDateText(DateTime date) {
  return "${date.day} - ${getMonthText(date)} - ${date.year}";
}

String getDateTextDayMonth(DateTime date) {
  return "${date.day} - ${getMonthText(date)}";
}

String getMonthText(DateTime date) {
  DateFormat formatter = DateFormat('MMM');
  return formatter.format(date);
}

List<DateTime> getWeekFirstAndLastDate(DateTime date) {
  return _getWeekFirstAndLastDateWithCondition(date, true);
}

List<DateTime> _getWeekFirstAndLastDateWithCondition(
    DateTime date, bool isSunday) {
  int weekDay = date.weekday;
  DateTime startDateOfTheWeek;
  DateTime endDateOfTheWeek;
  if (isSunday) {
    if (weekDay == 7) {
      startDateOfTheWeek = date;
    } else {
      startDateOfTheWeek = date.subtract(Duration(days: date.weekday));
    }
  } else {
    startDateOfTheWeek = date.subtract(Duration(days: date.weekday - 1));
  }
  endDateOfTheWeek = startDateOfTheWeek.add(const Duration(days: 6));
  return [
    DateTime(startDateOfTheWeek.year, startDateOfTheWeek.month,
        startDateOfTheWeek.day),
    DateTime(
        endDateOfTheWeek.year, endDateOfTheWeek.month, endDateOfTheWeek.day)
  ];
}

String getWeekRangeAsText(DateTime date) {
  List<DateTime> weekRange = getWeekFirstAndLastDate(date);
  var firstDayOfWeek = weekRange[0];
  var lastDayOfWeek = weekRange[1];
  return '${firstDayOfWeek.day} ${getMonthText(firstDayOfWeek)} - ${lastDayOfWeek.day} ${getMonthText(lastDayOfWeek)} ${date.year}';
}

String getMonthRangeAsText(DateTime date) {
  List<DateTime> monthRange = getFirstAndLastDayOfMonth(date);
  var firstDayOfMonth = monthRange[0];
  var lastDayOfMonth = monthRange[1];
  return '${firstDayOfMonth.day} ${getMonthText(date)} - ${lastDayOfMonth.day} ${getMonthText(date)} ${date.year}';
}

String getYearRangeAsText(DateTime date) {
  return 'Jan - Dec ${date.year}';
}

List<DateTime> getFirstAndLastDayOfMonth(DateTime date) {
  DateTime firstDayCurrentMonth = DateTime(date.year, date.month, 1);
  DateTime lastDayCurrentMonth = DateTime(
    date.year,
    date.month + 1,
  ).subtract(const Duration(days: 1));

  return [firstDayCurrentMonth, lastDayCurrentMonth];
}

List<DateTime> getFirstAndLastDayOfYear(DateTime date) {
  return [DateTime(date.year, 01, 01), DateTime(date.year, 12, 31)];
}
