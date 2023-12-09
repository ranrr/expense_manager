import 'package:collection/collection.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/autofill.dart';
import 'package:expense_manager/model/category_grouped_balance.dart';
import 'package:expense_manager/model/record_day_grouped.dart';
import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data_line.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

String formatNumber(int number) {
  return formatter.format(number).toString();
}

int getExpenseOfRecords(List<TxnRecord> records) {
  return records
      .where((element) => element.type == RecordType.expense.name)
      .map((e) => e.amount)
      .toList()
      .fold(0, (value, element) => value + element);
}

int getIncomeOfRecords(List<TxnRecord> records) {
  return records
      .where((element) => element.type == RecordType.income.name)
      .map((e) => e.amount)
      .toList()
      .fold(0, (value, element) => value + element);
}

Map<String, List<TxnRecord>> groupByRecordType(List<TxnRecord> records) {
  return records.groupListsBy((rec) => rec.type);
}

Map<String, Map<String, List<TxnRecord>>> categoryGroupedRecords(
    List<TxnRecord> records) {
  records
      .where((element) => element.type == RecordType.expense.name)
      .groupListsBy((element) => element.category);
  Map<String, List<TxnRecord>> m =
      records.groupListsBy((element) => element.category);
  Map<String, Map<String, List<TxnRecord>>> finalGrouping = {};
  m.forEach((key, value) {
    Map<String, List<TxnRecord>> innergroup =
        value.groupListsBy((element) => element.subCategory);
    finalGrouping[key] = innergroup;
  });
  return finalGrouping;
}

int getIncomeByCategory(Map<String, List<TxnRecord>> recordsByCategory) {
  int income = 0;
  for (String category in recordsByCategory.keys) {
    income += getIncomeOfRecords(recordsByCategory[category]!);
  }
  return income;
}

int getExpenseByCategory(Map<String, List<TxnRecord>> recordsByCategory) {
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

InputDecoration recordFormDecoration(
    {required String text, required IconData iconData}) {
  return InputDecoration(
    labelText: text,
    icon: Icon(iconData),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 0.75, color: Colors.grey),
      borderRadius: BorderRadius.circular(15),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 1, color: Colors.blue),
      borderRadius: BorderRadius.circular(15),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(width: 0.5, color: Colors.red),
      borderRadius: BorderRadius.circular(15),
    ),
  );
}

Future<String> createAutoFillRecord(
    String autoFillName, TxnRecord record) async {
  AutoFill? autoFill = await getAutoFill(autoFillName);
  String message;
  if (autoFill == null) {
    Map<String, dynamic> map = record.toMap()..['name'] = autoFillName;
    var autoFill = AutoFill.fromRecord(map);
    await DBProvider.db.newAutoFillRecord(autoFill);
    message = 'Auto-Fill created.';
  } else {
    message = 'Auto-Fill name already exists.';
  }
  return message;
}

Future<AutoFill?> getAutoFill(String name) async {
  return await DBProvider.db.getAutoFill(name);
}

deleteAutoFill(String name) async {
  return await DBProvider.db.deleteAutoFill(name);
}

editAutoFill(String oldName, String newName) async {
  return await DBProvider.db.renameAutoFill(oldName, newName);
}

Future<List<AutoFill>> getAllAutoFillRecords() async {
  return await DBProvider.db.getAllAutoFillRecords();
}

addCategoryExclusion(String category) async {
  return await DBProvider.db.addAppProperty(
      propertyName: exclusionCategoryProperty, propertyValue: category);
}

Future<List<String>> getAllCategoryExclusions() async {
  return await DBProvider.db.getAppPropertyList(exclusionCategoryProperty);
}

Future<bool> checkDuplicateExclusion(String exclusion) async {
  List<String> exclusions =
      await DBProvider.db.getAppPropertyList(exclusionCategoryProperty);
  return exclusions.contains(exclusion);
}

deleteCategoryExclusion(String category) async {
  await DBProvider.db.deleteAppPropertyByValue(category);
}

double getBarChartHeight(int dataSize) {
  double chartHeight = (dataSize + 1) * 40;
  return chartHeight < 100 ? 120 : chartHeight;
}

double getColumnChartHeight(int dataSize) {
  // double chartHeight = (dataSize + 1) * 40;
  // return chartHeight < 100 ? 120 : chartHeight;
  return 450;
}

double getDoughnutChartHeight() {
  // double chartHeight = (dataSize + 1) * 40;
  // return chartHeight < 100 ? 120 : chartHeight;
  return 450;
}

getNumericAxis() {
  return NumericAxis(
      labelRotation: -35,
      labelAlignment: LabelAlignment.start,
      anchorRangeToVisiblePoints: true,
      labelIntersectAction: AxisLabelIntersectAction.rotate90);
}

Future<List<ChartData>> getExpenseByCategoryChartData(
    {required DateTime fromDate,
    required DateTime toDate,
    bool isDrilled = false,
    String? category}) async {
  List<ChartData> data;
  if (isDrilled && category != null) {
    data = await DBProvider.db
        .expenseGroupedBySubCategory(fromDate, toDate, category);
  } else {
    data = await DBProvider.db.expenseGroupedByCategory(fromDate, toDate);
  }
  return data;
}

Future<Map<String, List<LineChartData>>> getExpenseByCategoryLineChartData(
    {required DateTime fromDate,
    required DateTime toDate,
    required List<String> categories}) async {
  if (categories.isEmpty) {
    return {};
  } else {
    List<LineChartData> data = await DBProvider.db
        .expenseGroupedMultipleCategory(fromDate, toDate, categories);
    Map<String, List<LineChartData>> groupedData =
        data.groupListsBy((element) => element.category);
    return groupedData;
  }
}
