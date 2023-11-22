import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/category_grouped_balance.dart';
import 'package:expense_manager/model/record.dart';
import 'package:collection/collection.dart';
import 'package:expense_manager/model/record_day_grouped.dart';
import 'package:expense_manager/utils/constants.dart';

String formatNumber(int number) {
  return formatter.format(number).toString();
}

int getExpenseOfRecords(List<Record> records) {
  return records
      .where((element) => element.type == RecordType.expense.name)
      .map((e) => e.amount)
      .toList()
      .fold(0, (value, element) => value + element);
}

int getIncomeOfRecords(List<Record> records) {
  return records
      .where((element) => element.type == RecordType.income.name)
      .map((e) => e.amount)
      .toList()
      .fold(0, (value, element) => value + element);
}

Map<String, List<Record>> groupByRecordType(List<Record> records) {
  return records.groupListsBy((rec) => rec.type);
}

Map<String, Map<String, List<Record>>> categoryGroupedRecords(
    List<Record> records) {
  records
      .where((element) => element.type == RecordType.expense.name)
      .groupListsBy((element) => element.category);
  Map<String, List<Record>> m =
      records.groupListsBy((element) => element.category);
  Map<String, Map<String, List<Record>>> finalGrouping = {};
  m.forEach((key, value) {
    Map<String, List<Record>> innergroup =
        value.groupListsBy((element) => element.subCategory);
    finalGrouping[key] = innergroup;
  });
  return finalGrouping;
}

int getIncomeByCategory(Map<String, List<Record>> recordsByCategory) {
  int income = 0;
  for (String category in recordsByCategory.keys) {
    income += getIncomeOfRecords(recordsByCategory[category]!);
  }
  return income;
}

int getExpenseByCategory(Map<String, List<Record>> recordsByCategory) {
  int income = 0;
  for (String category in recordsByCategory.keys) {
    income += getExpenseOfRecords(recordsByCategory[category]!);
  }
  return income;
}

Future<Map<String, List<CategoryGroupedBalance>>> getGroupedRecords(
    RecordType recordType, DateTime startDate, DateTime endDate) async {
  var func = (recordType.name == RecordType.expense.name)
      ? DBProvider.db.getCatSubcatGroupedExpenses
      : DBProvider.db.getCatSubcatGroupedIncomes;
  List<CategoryGroupedBalance> res = await func(startDate, endDate);
  return res.groupListsBy((element) => element.category);
}

Future<Map<DateTime, RecordDateGrouped>> getExpIncByDay(
    DateTime startDate, DateTime endDate) async {
  List<RecordDateGrouped> expences =
      await DBProvider.db.getExpensesByDay(startDate, endDate);
  List<RecordDateGrouped> incomes =
      await DBProvider.db.getIncomesByDay(startDate, endDate);
  List<RecordDateGrouped> expIncGroupedByDay = expences + incomes;
  Map<DateTime, RecordDateGrouped> recordsGroupedByDay = {};
  for (RecordDateGrouped ele in expIncGroupedByDay) {
    var groupedRecord = recordsGroupedByDay[ele.date];
    if (groupedRecord == null) {
      groupedRecord = ele;
      recordsGroupedByDay[ele.date] = ele;
    }
    if (ele.type == RecordType.expense) {
      groupedRecord.expense = ele.balance;
    } else {
      groupedRecord.income = ele.balance;
    }
  }
  return recordsGroupedByDay;
}

Future<Map<DateTime, RecordDateGrouped>> getExpIncByMonth(
    DateTime startDate, DateTime endDate) async {
  List<RecordDateGrouped> expences =
      await DBProvider.db.getExpensesByDay(startDate, endDate);
  List<RecordDateGrouped> incomes =
      await DBProvider.db.getIncomesByDay(startDate, endDate);
  List<RecordDateGrouped> expIncGroupedByDay = expences + incomes;
  Map<DateTime, RecordDateGrouped> recordsGroupedByMonth = {};
  for (RecordDateGrouped ele in expIncGroupedByDay) {
    var key = DateTime(ele.date.year, ele.date.month, 1);
    var groupedRecord = recordsGroupedByMonth[key];
    if (groupedRecord == null) {
      groupedRecord = ele;
      recordsGroupedByMonth[key] = ele;
    }
    if (ele.type == RecordType.expense) {
      groupedRecord.expense += ele.balance;
    } else {
      groupedRecord.income += ele.balance;
    }
  }
  return recordsGroupedByMonth;
}
