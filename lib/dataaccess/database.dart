import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:expense_manager/model/autofill.dart';
import 'package:expense_manager/model/category.dart';
import 'package:expense_manager/model/category_record.dart';
import 'package:expense_manager/model/record.dart';
import 'package:expense_manager/model/time_enum.dart';
import 'package:expense_manager/utils/date_utils.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const allAccountsName = "All";

class DBProvider {
  DBProvider._();

  String account = "Acc 1";

  static final DBProvider db = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!; //this cannot be null because of if check
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
  }

  FutureOr<void> _initializeDatabase(Database db, int version) async {
    // TODO check all these default inserts
    await db.execute("CREATE TABLE Record ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "account TEXT,"
        "type TEXT,"
        "amount INTEGER,"
        "category TEXT,"
        "sub_category TEXT,"
        "date TEXT,"
        "description TEXT"
        ")");

    await db.execute("CREATE TABLE Categories ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "category TEXT,"
        "sub_category TEXT,"
        "type TEXT"
        ")");

    await db.execute("CREATE TABLE Autofill ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "name TEXT,"
        "account TEXT,"
        "type TEXT,"
        "amount INTEGER,"
        "category TEXT,"
        "sub_category TEXT,"
        "description TEXT"
        ")");

    await db.execute("CREATE TABLE Accounts ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "name TEXT"
        ")");

    await db.rawInsert("insert into Accounts (name) VALUES ('Acc 1')");
    await db.rawInsert("insert into Accounts (name) VALUES ('Acc 2')");
    // print(Sqflite.firstIntValue(
    //     await db.rawQuery('SELECT COUNT(*) FROM Record')));
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
    var count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Record'));
    return count;
  }

  dropData() async {
    final db = await database;
    await db.rawDelete("DELETE FROM Record");
    var count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Record'));
    return count;
  }

  Future<List<Category>> getCategories() async {
    final db = await database;
    String query = "select * from Categories";
    var res = await db.rawQuery(query);
    List<Category> list =
        res.isNotEmpty ? res.map((c) => Category.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Category>> getCategoriesByType(String type) async {
    final db = await database;
    String query = "select * from Categories where type = '$type' ";
    var res = await db.rawQuery(query);
    List<Category> list =
        res.isNotEmpty ? res.map((c) => Category.fromMap(c)).toList() : [];
    return list;
  }

  newRecord(Record record) async {
    if (record.id != null) {
      await deleteRecord(record);
    }
    final db = await database;
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Record (account,type,amount,category,sub_category,date,description)"
        " VALUES (?,?,?,?,?,?,?)",
        [
          record.account,
          record.type,
          record.amount,
          record.category,
          record.subCategory,
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

  deleteRecord(Record record) async {
    final db = await database;
    await db.rawQuery("DELETE FROM record where id = ${record.id}");
  }

  Future<List<Record>> getAllRecords() async {
    final db = await database;
    var res = await db.query("Record");
    List<Record> list =
        res.isNotEmpty ? res.map((c) => Record.fromMap(c)).toList() : [];
    return list;
  }

  //TODO change with account filter
  Future<List<Record>> getRecentRecords(int count) async {
    final db = await database;
    String query =
        "SELECT * FROM Record WHERE account = '$account' ORDER BY date LIMIT 10";
    var res = await db.rawQuery(query);
    List<Record> list =
        res.isNotEmpty ? res.map((c) => Record.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<AutoFill>> getAllAutoFillRecords() async {
    final db = await database;
    var res = await db.query("Autofill");
    List<AutoFill> list =
        res.isNotEmpty ? res.map((c) => AutoFill.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Record>> getAllRecordsByDate(
      DateTime date, String account) async {
    final db = await database;
    date = getDate(date);
    String query = "SELECT * FROM Record WHERE date = '${date.toString()}' ";
    if (account != allAccountsName) {
      query += "AND account = '$account' ";
    }
    var res = await db.rawQuery(query);
    List<Record> list =
        res.isNotEmpty ? res.map((c) => Record.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Record>> getAllRecordsBetweenDate(
      String account, DateTime fromDate,
      [DateTime? toDate]) async {
    toDate ??= getTodaysDate();
    String query =
        "SELECT * FROM Record WHERE date BETWEEN '${fromDate.toString()}' AND '${toDate.toString()}' ";
    if (account != allAccountsName) {
      query += "AND account = '$account' ";
    }
    final db = await database;
    var res = await db.rawQuery(query);
    List<Record> list =
        res.isNotEmpty ? res.map((c) => Record.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> getCurrentBalance() async {
    String expQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Expense' ";
    String incQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Income' ";
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

  Future<SummaryActivityData> getCurrentMonthData(String account) async {
    DateTime firstDayCurrentMonth =
        DateTime(DateTime.now().year, DateTime.now().month, 1);

    DateTime lastDayCurrentMonth = DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
    ).subtract(const Duration(days: 1));

    String expQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Expense' AND date BETWEEN '${firstDayCurrentMonth.toString()}' AND '${lastDayCurrentMonth.toString()}' ";
    String incQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Income' AND date BETWEEN '${firstDayCurrentMonth.toString()}' AND '${lastDayCurrentMonth.toString()}' ";
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

    return SummaryActivityData(totalIncome, totalExpense);
  }

  Future<SummaryActivityData> getCurrentYearData(String account) async {
    DateTime firstDayCurrentYear = DateTime(DateTime.now().year, 1, 1);

    DateTime lastDayCurrentYear = DateTime(DateTime.now().year, 12, 31);

    String expQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Expense' AND date BETWEEN '${firstDayCurrentYear.toString()}' AND '${lastDayCurrentYear.toString()}' ";
    String incQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Income' AND date BETWEEN '${firstDayCurrentYear.toString()}' AND '${lastDayCurrentYear.toString()}' ";

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

    return SummaryActivityData(totalIncome, totalExpense);
  }

  Future<SummaryActivityData> getCurrentWeekData(String account) async {
    List<DateTime> weekfirstAndLastDate =
        getWeekFirstAndLastDate(DateTime.now());
    DateTime firstDayOfWeek = weekfirstAndLastDate[0];

    DateTime lastDayOfWeek = weekfirstAndLastDate[1];

    String expQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Expense' AND date BETWEEN '${firstDayOfWeek.toString()}' AND '${lastDayOfWeek.toString()}' ";
    String incQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Income' AND date BETWEEN '${firstDayOfWeek.toString()}' AND '${lastDayOfWeek.toString()}' ";

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

    return SummaryActivityData(totalIncome, totalExpense);
  }

  Future<SummaryActivityData> getTodaysData(String account) async {
    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    String expQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Expense' AND date = '$today' ";
    String incQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Income' AND date = '$today' ";

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

    return SummaryActivityData(totalIncome, totalExpense);
  }

  Future<Map<ActivityTime, SummaryActivityData>> getSummaryData(
      String account) async {
    Map<ActivityTime, SummaryActivityData> summary = {};
    summary[ActivityTime.week] = await getCurrentWeekData(account);
    summary[ActivityTime.month] = await getCurrentMonthData(account);
    summary[ActivityTime.year] = await getCurrentYearData(account);
    return summary;
  }

  Future<List<CategoryRecordType>> getCategorySummaryOfMonth(
      String account) async {
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, 1);
    DateTime endDate = DateTime(now.year, now.month + 1, 0);
    String query =
        "select category, SUM(amount) as amount from Record where type = 'Expense' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' ";
    if (account != allAccountsName) {
      query += "AND account = '$account' ";
    }
    query += "GROUP BY category";
    final db = await database;

    // List<Map<String, Object?>> totalExpenseRes = await db.rawQuery(query);
    // print(totalExpenseRes);

    var res = await db.rawQuery(query);
    List<CategoryRecordType> list = res.isNotEmpty
        ? res.map((c) => CategoryRecordType.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<List<String>> getAppAccountsWithAll() async {
    var accounts = await getAppAccounts();
    accounts.add(allAccountsName);
    return accounts;
  }

  Future<List<String>> getAppAccounts() async {
    final db = await database;
    String query = "select * from Accounts";
    List<Map<String, Object?>> res = await db.rawQuery(query);
    var accounts = res.map((entry) => entry['name'].toString()).toList();
    return accounts;
  }

  deleteAccountAndRecords(String account) async {
    final db = await database;
    String query = "DELETE FROM Accounts where name = '$account' ";
    await db.rawDelete(query);
    query = "DELETE FROM record where account = '$account' ";
    await db.rawQuery(query);
  }

  renameAccountAndRecords(
      {required String oldAccountName, required String newAccountName}) async {
    final db = await database;
    String oldAccountId = await _getAppAccountId(oldAccountName);
    String query =
        "UPDATE Accounts SET name = '$newAccountName' where id = '$oldAccountId' ";
    await db.rawQuery(query);
    List<String> recordIds = await _getRecordIdsForAccount(oldAccountName);
    await db.update('Record', {'account': newAccountName},
        where: 'id IN (${List.filled(recordIds.length, '?').join(',')})',
        whereArgs: recordIds);
  }

  Future<String> _getAppAccountId(String account) async {
    String query = "select id from Accounts where name = '$account' ";
    final db = await database;
    var res = await db.rawQuery(query);
    return res[0]['id'].toString();
  }

  Future<List<String>> _getRecordIdsForAccount(String account) async {
    String query = "select id from record where account = '$account' ";
    final db = await database;
    var res = await db.rawQuery(query);
    return res.map((entry) => entry['id'].toString()).toList();
  }

  addNewAppAccount(String account) async {
    final db = await database;
    await db.rawInsert("insert into Accounts (name) VALUES ('$account')");
  }
}
