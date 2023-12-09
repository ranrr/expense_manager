import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:expense_manager/model/autofill.dart';
import 'package:expense_manager/model/category.dart' as cat;
import 'package:expense_manager/model/category_grouped_balance.dart';
import 'package:expense_manager/model/dashboard_grid_summary.dart';
import 'package:expense_manager/model/record_day_grouped.dart';
import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data_line.dart';
import 'package:expense_manager/widgets/reports/charts/chart_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  String account = allAccountsName;

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    // if _database is null we instantiate it
    await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "expensemanager.db");
    _database = await openDatabase(path,
        version: 1, onOpen: (db) {}, onCreate: _initializeDatabase);
    debugPrint("***************DB init Done... ***************");
  }

  FutureOr<void> _initializeDatabase(Database db, int version) async {
    await db.execute("CREATE TABLE IF NOT EXISTS Records ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "account TEXT,"
        "type TEXT,"
        "amount INTEGER,"
        "category TEXT,"
        "sub_category TEXT,"
        "category_text TEXT,"
        "date TEXT,"
        "description TEXT"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS Categories ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "category TEXT,"
        "sub_category TEXT,"
        "type TEXT"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS Autofill ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "name TEXT,"
        "account TEXT,"
        "type TEXT,"
        "amount INTEGER,"
        "category TEXT,"
        "sub_category TEXT,"
        "description TEXT"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS Accounts ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "name TEXT"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS AppProperty ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "property TEXT,"
        "value TEXT"
        ")");

    await db
        .rawInsert("insert into Accounts (name) VALUES ('$allAccountsName')");
    await db.rawInsert("insert into Accounts (name) VALUES ('Account A')");

    await db.rawInsert(
        "insert into AppProperty (property, value) VALUES ('$selectedAccountProperty','$allAccountsName')");

    await db.rawInsert(
        "insert into AppProperty (property, value) VALUES ('$dbBackupPath','') ");

    String line = await loadAsset('assets/data/categories.txt');
    const LineSplitter ls = LineSplitter();
    List<String> lines = ls.convert(line);
    for (line in lines) {
      await db.rawInsert(line);
    }
  }

  Future<String> loadAsset(String file) async {
    return await rootBundle.loadString(file);
  }

  loadCategories() async {
    String line = await loadAsset('assets/data/categories.txt');
    const LineSplitter ls = LineSplitter();
    List<String> lines = ls.convert(line);
    final db = await database;
    for (line in lines) {
      await db.rawInsert(line);
    }
  }

  loadData() async {
    String line = await loadAsset('assets/data/data.txt');
    const LineSplitter ls = LineSplitter();
    List<String> lines = ls.convert(line);
    final db = await database;
    for (line in lines) {
      await db.rawInsert(line);
    }
    var count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Records'));
    debugPrint(
        "******************** Inserted $count records ********************");
    return count;
  }

  Future<List<cat.Category>> getCategories() async {
    final db = await database;
    String query = "select * from Categories";
    var res = await db.rawQuery(query);
    List<cat.Category> list =
        res.isNotEmpty ? res.map((c) => cat.Category.fromMap(c)).toList() : [];
    return list;
  }

  Future<String> getAppProperty(String propertyName) async {
    final db = await database;
    String query =
        "select value from AppProperty where property = '$propertyName'";
    var res = await db.rawQuery(query);
    var account = res[0]['value'].toString();
    return account;
  }

  deleteAppPropertyByValue(String propertyValue) async {
    final db = await database;
    String query = "delete from AppProperty where value = '$propertyValue'";
    await db.rawQuery(query);
  }

  Future<List<String>> getAppPropertyList(String propertyName) async {
    final db = await database;
    String query =
        "select value from AppProperty where property = '$propertyName'";
    var res = await db.rawQuery(query);
    List<String> list =
        res.isNotEmpty ? res.map((c) => c['value'].toString()).toList() : [];
    return list;
  }

  Future<void> updateSelectedAccount({required String selectedAccount}) async {
    updateAppProperty(
        propertyName: selectedAccountProperty, propertyValue: selectedAccount);
  }

  Future<void> addAppProperty(
      {required String propertyName, required String propertyValue}) async {
    final db = await database;
    await db.rawInsert(
        "insert into AppProperty (property, value) VALUES ('$propertyName','$propertyValue')");
  }

  Future<void> updateAppProperty(
      {required String propertyName, required String propertyValue}) async {
    final db = await database;
    String query =
        "update AppProperty set value = '$propertyValue' where property = '$propertyName'";
    await db.rawUpdate(query);
  }

  newRecord(TxnRecord record) async {
    if (record.id != null) {
      await deleteRecord(record);
    }
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Records (account,type,amount,category,sub_category,category_text,date,description)"
        " VALUES (?,?,?,?,?,?,?,?)",
        [
          record.account,
          record.type,
          record.amount,
          record.category,
          record.subCategory,
          record.categoryText,
          record.date.toString(),
          record.description
        ]);
    return raw;
  }

  newAutoFillRecord(AutoFill autoFillRecord) async {
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Autofill (name,account,type,amount,category,sub_category,description)"
        " VALUES (?,?,?,?,?,?,?)",
        [
          autoFillRecord.name,
          autoFillRecord.account,
          autoFillRecord.type,
          autoFillRecord.amount,
          autoFillRecord.category,
          autoFillRecord.subCategory,
          autoFillRecord.description
        ]);
    return raw;
  }

  deleteRecord(TxnRecord record) async {
    final db = await database;
    await db.rawQuery("DELETE FROM Records where id = ${record.id}");
  }

  deleteRecordById(int id) async {
    final db = await database;
    await db.rawQuery("DELETE FROM Records where id = $id");
  }

  Future<List<TxnRecord>> getRecentRecords(int count) async {
    final db = await database;
    String? query;
    if (account == allAccountsName) {
      query = "SELECT * FROM Records ORDER BY date DESC LIMIT $count";
    } else {
      query =
          "SELECT * FROM Records WHERE account = '$account' ORDER BY date DESC LIMIT $count";
    }
    var res = await db.rawQuery(query);
    List<TxnRecord> list =
        res.isNotEmpty ? res.map((c) => TxnRecord.fromMap(c)).toList() : [];
    return list;
  }

  Future<TxnRecord> getRecordById(int id) async {
    final db = await database;
    String query = "SELECT * FROM Records WHERE id = $id";
    var res = await db.rawQuery(query);
    return TxnRecord.fromMap(res[0]);
  }

  Future<List<AutoFill>> getAllAutoFillRecords() async {
    final db = await database;
    var res = await db.query("Autofill");
    List<AutoFill> list =
        res.isNotEmpty ? res.map((c) => AutoFill.fromMap(c)).toList() : [];
    return list;
  }

  Future<AutoFill?> getAutoFill(String name) async {
    final db = await database;
    String query = "SELECT * FROM Autofill WHERE name = '$name' ";
    var res = await db.rawQuery(query);
    AutoFill? autoFillRecord = res.isNotEmpty ? AutoFill.fromMap(res[0]) : null;
    return autoFillRecord;
  }

  deleteAutoFill(String name) async {
    final db = await database;
    String query = "DELETE FROM Autofill where name = '$name' ";
    await db.rawQuery(query);
  }

  renameAutoFill(String oldName, String newName) async {
    final db = await database;
    String query =
        "update Autofill set name = '$newName' where name = '$oldName' ";
    await db.rawQuery(query);
  }

  Future<List<TxnRecord>> getAllRecordsByDate(DateTime date) async {
    final db = await database;
    date = getDate(date);
    String query = "SELECT * FROM Records WHERE date = '${date.toString()}' ";
    if (account != allAccountsName) {
      query += "AND account = '$account' ";
    }
    var res = await db.rawQuery(query);
    List<TxnRecord> list =
        res.isNotEmpty ? res.map((c) => TxnRecord.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<TxnRecord>> getAllRecordsBetweenDate(
    DateTime fromDate, [
    DateTime? toDate,
    String? category,
    String? subCategory,
  ]) async {
    toDate ??= getTodaysDate();
    String query =
        "SELECT * FROM Records WHERE date BETWEEN '${fromDate.toString()}' AND '${toDate.toString()}' ";
    if (account != allAccountsName) {
      query += "AND account = '$account' ";
    }
    if (category != null && category.isNotEmpty) {
      query += "AND category = '$category' AND sub_category = '$subCategory' ";
    }
    final db = await database;
    var res = await db.rawQuery(query);
    List<TxnRecord> list =
        res.isNotEmpty ? res.map((c) => TxnRecord.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> getCurrentBalance() async {
    String expQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Expense' ";
    String incQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Income' ";
    if (account != allAccountsName) {
      expQuery += "AND account = '$account' ";
      incQuery += "AND account = '$account' ";
    }
    final db = await database;
    List<Map<String, Object?>> totalExpenseRes = await db.rawQuery(expQuery);
    List<Map<String, Object?>> totalIncomeRes = await db.rawQuery(incQuery);

    int totalExpense = (totalExpenseRes[0]['balance'] == null)
        ? 0
        : int.parse(totalExpenseRes[0]['balance'].toString());

    int totalIncome = (totalIncomeRes[0]['balance'] == null)
        ? 0
        : int.parse(totalIncomeRes[0]['balance'].toString());

    int currentBalance = totalIncome - totalExpense;
    return currentBalance;
  }

  Future<(int, int)> getTotalIncomeAndExpense(
      DateTime startDate, DateTime endDate) async {
    int totalIncome = await getTotalIncome(startDate, endDate);
    int totalExpense = await getTotalExpense(startDate, endDate);
    return (totalIncome, totalExpense);
  }

  Future<int> getTotalIncome(DateTime startDate, DateTime endDate) async {
    String incomeQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Income' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' ";
    if (account != allAccountsName) {
      incomeQuery += "AND account = '$account' ";
    }
    final db = await database;
    List<Map<String, Object?>> totalIncomeRes = await db.rawQuery(incomeQuery);
    int totalIncome = (totalIncomeRes[0]['balance'] == null)
        ? 0
        : int.parse(totalIncomeRes[0]['balance'].toString());
    return totalIncome;
  }

  Future<int> getTotalExpense(DateTime startDate, DateTime endDate) async {
    String expQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Expense' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' ";
    if (account != allAccountsName) {
      expQuery += "AND account = '$account' ";
    }
    final db = await database;
    List<Map<String, Object?>> totalExpenseRes = await db.rawQuery(expQuery);
    int totalExpense = (totalExpenseRes[0]['balance'] == null)
        ? 0
        : int.parse(totalExpenseRes[0]['balance'].toString());
    return totalExpense;
  }

  Future<List<RecordDateGrouped>> getExpensesByDay(
      DateTime startDate, DateTime endDate) async {
    String expQuery;
    if (account != allAccountsName) {
      expQuery =
          "SELECT date, type, SUM(amount) as balance from Records where type = 'Expense' AND account = '$account' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by date";
    } else {
      expQuery =
          "SELECT date, type, SUM(amount) as balance from Records where type = 'Expense' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by date";
    }
    final db = await database;
    List<Map<String, Object?>> res = await db.rawQuery(expQuery);
    List<RecordDateGrouped> list = res.isNotEmpty
        ? res.map((c) => RecordDateGrouped.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<List<RecordDateGrouped>> getIncomesByDay(
      DateTime startDate, DateTime endDate) async {
    String incomeQuery;
    if (account != allAccountsName) {
      incomeQuery =
          "SELECT date, type, SUM(amount) as balance from Records where type = 'Income' AND account = '$account' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by date";
    } else {
      incomeQuery =
          "SELECT date, type, SUM(amount) as balance from Records where type = 'Income' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by date";
    }
    final db = await database;
    List<Map<String, Object?>> res = await db.rawQuery(incomeQuery);
    List<RecordDateGrouped> list = res.isNotEmpty
        ? res.map((c) => RecordDateGrouped.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<DashboardGridSummary> getCurrentMonthData() async {
    DateTime firstDayCurrentMonth =
        DateTime(DateTime.now().year, DateTime.now().month, 1);

    DateTime lastDayCurrentMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(const Duration(days: 1));

    String expQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Expense' AND date BETWEEN '${firstDayCurrentMonth.toString()}' AND '${lastDayCurrentMonth.toString()}' ";
    String incQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Income' AND date BETWEEN '${firstDayCurrentMonth.toString()}' AND '${lastDayCurrentMonth.toString()}' ";
    if (account != allAccountsName) {
      expQuery += "AND account = '$account' ";
      incQuery += "AND account = '$account' ";
    }
    final db = await database;
    List<Map<String, Object?>> totalExpenseRes = await db.rawQuery(expQuery);
    List<Map<String, Object?>> totalIncomeRes = await db.rawQuery(incQuery);

    int totalExpense = (totalExpenseRes[0]['balance'] == null)
        ? 0
        : int.parse(totalExpenseRes[0]['balance'].toString());

    int totalIncome = (totalIncomeRes[0]['balance'] == null)
        ? 0
        : int.parse(totalIncomeRes[0]['balance'].toString());
    return DashboardGridSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        period: Period.month);
  }

  Future<DashboardGridSummary> getCurrentYearData() async {
    DateTime firstDayCurrentYear = DateTime(DateTime.now().year, 1, 1);

    DateTime lastDayCurrentYear = DateTime(DateTime.now().year, 12, 31);

    String expQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Expense' AND date BETWEEN '${firstDayCurrentYear.toString()}' AND '${lastDayCurrentYear.toString()}' ";
    String incQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Income' AND date BETWEEN '${firstDayCurrentYear.toString()}' AND '${lastDayCurrentYear.toString()}' ";

    if (account != allAccountsName) {
      expQuery += "AND account = '$account' ";
      incQuery += "AND account = '$account' ";
    }

    final db = await database;

    List<Map<String, Object?>> totalExpenseRes = await db.rawQuery(expQuery);
    List<Map<String, Object?>> totalIncomeRes = await db.rawQuery(incQuery);

    int totalExpense = (totalExpenseRes[0]['balance'] == null)
        ? 0
        : int.parse(totalExpenseRes[0]['balance'].toString());

    int totalIncome = (totalIncomeRes[0]['balance'] == null)
        ? 0
        : int.parse(totalIncomeRes[0]['balance'].toString());
    return DashboardGridSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        period: Period.year);
  }

  Future<DashboardGridSummary> getCurrentWeekData() async {
    List<DateTime> weekfirstAndLastDate =
        getWeekFirstAndLastDate(DateTime.now());
    DateTime firstDayOfWeek = weekfirstAndLastDate[0];

    DateTime lastDayOfWeek = weekfirstAndLastDate[1];

    String expQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Expense' AND date BETWEEN '${firstDayOfWeek.toString()}' AND '${lastDayOfWeek.toString()}' ";
    String incQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Income' AND date BETWEEN '${firstDayOfWeek.toString()}' AND '${lastDayOfWeek.toString()}' ";

    if (account != allAccountsName) {
      expQuery += "AND account = '$account' ";
      incQuery += "AND account = '$account' ";
    }

    final db = await database;

    List<Map<String, Object?>> totalExpenseRes = await db.rawQuery(expQuery);
    List<Map<String, Object?>> totalIncomeRes = await db.rawQuery(incQuery);

    int totalExpense = (totalExpenseRes[0]['balance'] == null)
        ? 0
        : int.parse(totalExpenseRes[0]['balance'].toString());

    int totalIncome = (totalIncomeRes[0]['balance'] == null)
        ? 0
        : int.parse(totalIncomeRes[0]['balance'].toString());

    return DashboardGridSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        period: Period.week);
  }

  Future<List<CategoryGroupedBalance>> getCatSubcatGroupedExpenses(
      DateTime startDate, DateTime endDate) async {
    String query;
    if (account != allAccountsName) {
      query =
          "select category, sub_category, SUM(amount) as amount from Records where type = 'Expense' AND account = '$account' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by category, sub_category;";
    } else {
      query =
          "select category, sub_category, SUM(amount) as amount from Records where type = 'Expense' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by category, sub_category;";
    }
    final db = await database;
    var res = await db.rawQuery(query);
    List<CategoryGroupedBalance> groupedBalances = res.isNotEmpty
        ? res.map((c) => CategoryGroupedBalance.fromMap(c)).toList()
        : [];
    return groupedBalances;
  }

  Future<List<CategoryGroupedBalance>> getCatSubcatGroupedIncomes(
      DateTime startDate, DateTime endDate) async {
    String query;
    if (account != allAccountsName) {
      query =
          "select category, sub_category, SUM(amount) as amount from Records where type = 'Income' AND account = '$account' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by category;";
    } else {
      query =
          "select category, sub_category, SUM(amount) as amount from Records where type = 'Income' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by category;";
    }
    final db = await database;
    var res = await db.rawQuery(query);
    List<CategoryGroupedBalance> groupedBalances = res.isNotEmpty
        ? res.map((c) => CategoryGroupedBalance.fromMap(c)).toList()
        : [];
    return groupedBalances;
  }

  Future<DashboardGridSummary> getTodaysData() async {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    String expQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Expense' AND date = '$today' ";
    String incQuery =
        "SELECT SUM(amount) as balance from Records where type = 'Income' AND date = '$today' ";

    if (account != allAccountsName) {
      expQuery += "AND account = '$account' ";
      incQuery += "AND account = '$account' ";
    }

    final db = await database;
    List<Map<String, Object?>> totalExpenseRes = await db.rawQuery(expQuery);
    List<Map<String, Object?>> totalIncomeRes = await db.rawQuery(incQuery);

    int totalExpense = (totalExpenseRes[0]['balance'] == null)
        ? 0
        : int.parse(totalExpenseRes[0]['balance'].toString());

    int totalIncome = (totalIncomeRes[0]['balance'] == null)
        ? 0
        : int.parse(totalIncomeRes[0]['balance'].toString());
    return DashboardGridSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        period: Period.today);
  }

  Future<List<String>> getAppAccounts() async {
    final db = await database;
    String query = "select * from Accounts order by id DESC";
    List<Map<String, Object?>> res = await db.rawQuery(query);
    var accounts = res.map((entry) => entry['name'].toString()).toList();
    return accounts;
  }

  resetDB() async {
    final db = await database;
    db.delete("Records");
    db.delete("Categories");
    db.delete("Autofill");
    db.delete("Accounts");
    db.delete("AppProperty");
    await _initializeDatabase(db, 1);
    debugPrint(
        "****************************App reset done****************************");
  }

  deleteAccountAndRecords(String account) async {
    final db = await database;
    await db.rawQuery("DELETE FROM Accounts where name = '$account' ");
    await db.rawQuery("DELETE FROM Records where account = '$account' ");
  }

  renameAccountAndRecords(String oldAccount, String newAccount) async {
    final db = await database;
    if (account == oldAccount) {
      updateSelectedAccount(selectedAccount: newAccount);
    }
    await db.rawQuery(
        "update Accounts set name = '$newAccount' where name = '$oldAccount'");
    await db.rawQuery(
        "update Records set account = '$newAccount' where account = '$oldAccount'");
  }

  deleteExpenseCategoryAndRecords(String category) async {
    final db = await database;
    await db.rawQuery(
        "DELETE FROM Categories where category = '$category' and type = '${RecordType.expense.name}' ");
    await db.rawQuery(
        "DELETE FROM Records where category = '$category' and type = '${RecordType.expense.name}' ");
  }

  deleteExpenseSubCategoryAndRecords(
      String category, String subCategory) async {
    final db = await database;
    await db.rawQuery(
        "DELETE FROM Categories where category = '$category' and sub_category = '$subCategory' and type = '${RecordType.expense.name}' ");
    await db.rawQuery(
        "DELETE FROM Records where category = '$category' and sub_category = '$subCategory' and type = '${RecordType.expense.name}' ");
  }

  renameExpenseCategoryAndRecords(
      String oldCategory, String newCategory) async {
    final db = await database;
    await db.rawQuery(
        "update Categories set category = '$newCategory' where category = '$oldCategory' and type = '${RecordType.expense.name}' ");
    await db.rawQuery(
        "update Records set category = '$newCategory' where category = '$oldCategory' and type = '${RecordType.expense.name}' ");
  }

  renameExpenseSubCategoryAndRecords(
      String category, String oldSubCategory, String newSubCategory) async {
    final db = await database;
    await db.rawQuery(
        "update Categories set sub_category = '$newSubCategory' where category = '$category'and sub_category = '$oldSubCategory' and type = '${RecordType.expense.name}' ");
    await db.rawQuery(
        "update Records set sub_category = '$newSubCategory' where category = '$category'and sub_category = '$oldSubCategory' and type = '${RecordType.expense.name}' ");
  }

  addNewAccount(String account) async {
    final db = await database;
    await db.rawInsert("insert into Accounts (name) VALUES ('$account')");
  }

  addNewExpenseCategory(String category, String subCategory) async {
    final db = await database;
    await db.rawInsert(
        "insert into Categories (category,sub_category,type) VALUES ('$category','$subCategory','${RecordType.expense.name}') ");
  }

  addNewIncomeCategory(String category, String subCategory) async {
    final db = await database;
    await db.rawInsert(
        "insert into Categories (category,sub_category,type) VALUES ('$category','$subCategory','${RecordType.income.name}') ");
  }

  renameIncomeCategoryAndRecords(String oldCategory, String newCategory) async {
    final db = await database;
    await db.rawQuery(
        "update Categories set category = '$newCategory' where category = '$oldCategory' and type = '${RecordType.income.name}' ");
    await db.rawQuery(
        "update Records set category = '$newCategory', sub_category = '$newCategory' where category = '$oldCategory' and type = '${RecordType.income.name}' ");
  }

  deleteIncomeCategoryAndRecords(String category) async {
    final db = await database;
    await db.rawQuery(
        "DELETE FROM Categories where category = '$category' and type = '${RecordType.income.name}' ");
    await db.rawQuery(
        "DELETE FROM Records where category = '$category' and type = '${RecordType.income.name}' ");
  }

  Future<List<TxnRecord>> searchRecords(
      {required String searchText,
      required String type,
      DateTime? from,
      DateTime? to}) async {
    final db = await database;
    String query =
        "select * from Records where (description like '%$searchText%' or category like  '%$searchText%' or sub_category like '%$searchText%' or amount like '%$searchText%') ";
    if (from != null) {
      query += "and date BETWEEN '${from.toString()}' AND '${to.toString()}' ";
    }
    if (type == RecordType.expense.name) {
      query += "and type = '${RecordType.expense.name}' ";
    } else if (type == RecordType.income.name) {
      query += "and type = '${RecordType.income.name}' ";
    }
    if (account != allAccountsName) {
      query += "and account = '$account' ";
    }

    var res = await db.rawQuery(query);
    List<TxnRecord> list =
        res.isNotEmpty ? res.map((c) => TxnRecord.fromMap(c)).toList() : [];
    return list;
  }

  Future<String> getExclusionsText() async {
    List<String> exclusions =
        await getAppPropertyList(exclusionCategoryProperty);
    String exclusionText = "(";
    for (String exclusion in exclusions) {
      exclusionText += "'$exclusion',";
    }
    exclusionText += "'')";
    return exclusionText;
  }

  Future<String> getCategoriesText(List<String> categories) async {
    String categoriesText = "(";
    for (String exclusion in categories) {
      categoriesText += "'$exclusion',";
    }
    categoriesText += "'')";
    return categoriesText;
  }

  Future<List<ChartData>> totalExpenseGroupedByMonth(
      DateTime fromDate, DateTime toDate) async {
    String exclusionText = await getExclusionsText();
    String query =
        """ SELECT strftime('%Y-%m', date) AS str, sum(amount) as amount FROM Records WHERE date 
        BETWEEN '${fromDate.toString()}' AND '${toDate.toString()}' and type = '${RecordType.expense.name}' 
        and category_text not in $exclusionText """;
    if (account != allAccountsName) {
      query += "AND account = '$account' ";
    }
    query += "GROUP BY str ORDER BY str";
    final db = await database;
    var res = await db.rawQuery(query);
    List<ChartData> data =
        res.isNotEmpty ? res.map((c) => ChartData.fromMap(c)).toList() : [];
    return data;
  }

  Future<List<ChartData>> totalIncomeGroupedByMonth(
      DateTime fromDate, DateTime toDate) async {
    String exclusionText = await getExclusionsText();
    String query =
        """ SELECT strftime('%Y-%m', date) AS str, sum(amount) as amount FROM Records WHERE date 
        BETWEEN '${fromDate.toString()}' AND '${toDate.toString()}' and type = '${RecordType.income.name}' 
        and category_text not in $exclusionText """;
    if (account != allAccountsName) {
      query += "AND account = '$account' ";
    }
    query += "GROUP BY str ORDER BY str";
    final db = await database;
    var res = await db.rawQuery(query);
    List<ChartData> data =
        res.isNotEmpty ? res.map((c) => ChartData.fromMap(c)).toList() : [];
    return data;
  }

  Future<List<ChartData>> expenseGroupedByCategory(
      DateTime fromDate, DateTime toDate) async {
    String exclusionText = await getExclusionsText();
    String query =
        """ SELECT category as str, sum(amount) as amount FROM Records WHERE date 
        BETWEEN '${fromDate.toString()}' AND '${toDate.toString()}' and type = '${RecordType.expense.name}' 
        and category_text not in $exclusionText """;
    if (account != allAccountsName) {
      query += "AND account = '$account' ";
    }
    query += "GROUP BY str";
    final db = await database;
    var res = await db.rawQuery(query);
    List<ChartData> data =
        res.isNotEmpty ? res.map((c) => ChartData.fromMap(c)).toList() : [];
    return data;
  }

  Future<List<LineChartData>> expenseGroupedMultipleCategory(
      DateTime fromDate, DateTime toDate, List<String> categories) async {
    String exclusionText = await getExclusionsText();
    String categriesText = await getCategoriesText(categories);
    String query =
        """ SELECT strftime('%Y-%m', date) AS str, category as category, sum(amount) as amount, date as date  FROM Records WHERE date 
        BETWEEN '${fromDate.toString()}' AND '${toDate.toString()}' and type = '${RecordType.expense.name}' 
        and category_text not in $exclusionText 
        and category in $categriesText """;
    if (account != allAccountsName) {
      query += "AND account = '$account' ";
    }
    query += "GROUP BY str, category ORDER BY str";
    final db = await database;
    var res = await db.rawQuery(query);
    List<LineChartData> data =
        res.isNotEmpty ? res.map((c) => LineChartData.fromMap(c)).toList() : [];
    return data;
  }

  Future<List<ChartData>> expenseGroupedBySubCategory(
      DateTime fromDate, DateTime toDate, String category) async {
    String exclusionText = await getExclusionsText();
    String query =
        """ SELECT sub_category as str, sum(amount) as amount FROM Records WHERE date 
        BETWEEN '${fromDate.toString()}' AND '${toDate.toString()}' and type = '${RecordType.expense.name}' 
        and category = '$category'
        and category_text not in $exclusionText """;
    if (account != allAccountsName) {
      query += "AND account = '$account' ";
    }
    query += "GROUP BY str";
    final db = await database;
    var res = await db.rawQuery(query);
    List<ChartData> data =
        res.isNotEmpty ? res.map((c) => ChartData.fromMap(c)).toList() : [];
    return data;
  }

  Future<List<ChartData>> incomeGroupedByCategory(
      DateTime fromDate, DateTime toDate) async {
    String exclusionText = await getExclusionsText();
    String query =
        """ SELECT category as str, sum(amount) as amount FROM Records WHERE date 
        BETWEEN '${fromDate.toString()}' AND '${toDate.toString()}' and type = '${RecordType.income.name}' 
        and category_text not in $exclusionText """;
    if (account != allAccountsName) {
      query += "AND account = '$account' ";
    }
    query += "GROUP BY str";
    final db = await database;
    var res = await db.rawQuery(query);
    List<ChartData> data =
        res.isNotEmpty ? res.map((c) => ChartData.fromMap(c)).toList() : [];
    return data;
  }

  // renameAccountAndRecords(
  //     {required String oldAccountName, required String newAccountName}) async {
  //   final db = await database;
  //   String oldAccountId = await _getAppAccountId(oldAccountName);
  //   String query =
  //       "UPDATE Accounts SET name = '$newAccountName' where id = '$oldAccountId' ";
  //   await db.rawQuery(query);
  //   List<String> recordIds = await _getRecordIdsForAccount(oldAccountName);
  //   await db.update('Record', {'account': newAccountName},
  //       where: 'id IN (${List.filled(recordIds.length, '?').join(',')})',
  //       whereArgs: recordIds);
  // }

  // Future<String> _getAppAccountId(String account) async {
  //   String query = "select id from Accounts where name = '$account' ";
  //   final db = await database;
  //   var res = await db.rawQuery(query);
  //   return res[0]['id'].toString();
  // }

  // Future<List<String>> _getRecordIdsForAccount(String account) async {
  //   String query = "select id from record where account = '$account' ";
  //   final db = await database;
  //   var res = await db.rawQuery(query);
  //   return res.map((entry) => entry['id'].toString()).toList();
  // }

  // addNewAppAccount(String account) async {
  //   final db = await database;
  //   await db.rawInsert("insert into Accounts (name) VALUES ('$account')");
  // }

  // Future<List<Category>> getCategoriesByType(String type) async {
  //   final db = await database;
  //   String query = "select * from Categories where type = '$type' ";
  //   var res = await db.rawQuery(query);
  //   List<Category> list =
  //       res.isNotEmpty ? res.map((c) => Category.fromMap(c)).toList() : [];
  //   return list;
  // }

  // Future<Map<ActivityTime, RecordsSummary>> getSummaryData(
  //     String account) async {
  //   Map<ActivityTime, RecordsSummary> summary = {};
  //   summary[ActivityTime.week] = await getCurrentWeekData();
  //   summary[ActivityTime.month] = await getCurrentMonthData();
  //   summary[ActivityTime.year] = await getCurrentYearData();
  //   return summary;
  // }

  // Future<List<CategoryRecordType>> getCategorySummaryOfMonth(
  //     String account) async {
  //   DateTime now = DateTime.now();
  //   DateTime startDate = DateTime(now.year, now.month, 1);
  //   DateTime endDate = DateTime(now.year, now.month + 1, 0);
  //   String query =
  //       "select category, SUM(amount) as amount from Record where type = 'Expense' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' ";
  //   if (account != allAccountsName) {
  //     query += "AND account = '$account' ";
  //   }
  //   query += "GROUP BY category";
  //   final db = await database;

  //   // List<Map<String, Object?>> totalExpenseRes = await db.rawQuery(query);
  //   // print(totalExpenseRes);

  //   var res = await db.rawQuery(query);
  //   List<CategoryRecordType> list = res.isNotEmpty
  //       ? res.map((c) => CategoryRecordType.fromMap(c)).toList()
  //       : [];
  //   return list;
  // }

  // Future<List<String>> getAppAccountsWithAll() async {
  //   var accounts = await getAppAccounts();
  //   accounts.add(allAccountsName);
  //   return accounts;
  // }

  // Future<List<RecordDayGrouped>> getExpensesByMonth(
  //     DateTime startDate, DateTime endDate) async {
  //   startDate = DateTime(2023, DateTime.january, 1);
  //   endDate = DateTime(2023, DateTime.december, 31);
  //   String incomeQuery =
  //       "SELECT date, type, SUM(amount) as balance from Record where type = 'Expense' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}'  STRFTIME(\"%m-%Y\", date)";
  //   final db = await database;
  //   List<Map<String, Object?>> res = await db.rawQuery(incomeQuery);
  //   List<RecordDayGrouped> list = res.isNotEmpty
  //       ? res.map((c) => RecordDayGrouped.fromMap(c)).toList()
  //       : [];
  //   return list;
  // }

  // Future<List<RecordDateGrouped>> getIncomesByMonth(
  //     DateTime startDate, DateTime endDate) async {
  //   String incomeQuery =
  //       "SELECT date, type, SUM(amount) as balance from Record where type = 'Income' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by date";
  //   final db = await database;
  //   List<Map<String, Object?>> res = await db.rawQuery(incomeQuery);
  //   List<RecordDateGrouped> list = res.isNotEmpty
  //       ? res.map((c) => RecordDateGrouped.fromMap(c)).toList()
  //       : [];
  //   return list;
  // }

  // Future<List<Record>> getAllRecords() async {
  //   final db = await database;
  //   var res = await db.query("Record");
  //   List<Record> list =
  //       res.isNotEmpty ? res.map((c) => Record.fromMap(c)).toList() : [];
  //   return list;
  // }
}
