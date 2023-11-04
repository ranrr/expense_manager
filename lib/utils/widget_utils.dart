import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/record.dart';
import 'package:collection/collection.dart';
import 'package:expense_manager/utils/constants.dart';

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

Future<Map<String, List<Map<String, Object?>>>> getGroupedRecords(
    RecordType recordType, DateTime startDate, DateTime endDate) async {
  var func = (recordType.name == RecordType.expense.name)
      ? DBProvider.db.getCatSubcatGroupedExpences
      : DBProvider.db.getCatSubcatGroupedIncomes;
  List<Map<String, Object?>> res = await func(startDate, endDate);
  return res.groupListsBy((element) => element['category'].toString());
}
