enum ActivityTime {
  day("Day", 0),
  week("Week", 1),
  month("Month", 2),
  year("Year", 3);

  const ActivityTime(this.value, this.position);
  final String value;
  final int position;
}

class SummaryActivityData {
  int totalIncome;
  int totalExpense;
  SummaryActivityData(this.totalIncome, this.totalExpense);
}
