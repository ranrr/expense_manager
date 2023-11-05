import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:expense_manager/model/autofill.dart';
import 'package:expense_manager/model/category.dart';
import 'package:expense_manager/model/record.dart';
import 'package:expense_manager/model/record_day_grouped.dart';
import 'package:expense_manager/model/records_summary.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/date_utils.dart';
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
    print("***************DB init Done... ***************");
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

    await db.execute("CREATE TABLE AppProperty ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "property TEXT,"
        "value TEXT"
        ")");

    await db
        .rawInsert("insert into Accounts (name) VALUES ('$allAccountsName')");

    //TODO remove this when publishing
    await db.rawInsert("insert into Accounts (name) VALUES ('SBI')");
    await db.rawInsert("insert into Accounts (name) VALUES ('HDFC')");
    loadData();
    ///////////////////////////////////

    await db.rawInsert(
        "insert into AppProperty (property, value) VALUES ('$selectedAccountProperty','$allAccountsName')");

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
    print("******************** Inserted $count records ********************");
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

  Future<String> getAppProperty(String propertyName) async {
    final db = await database;
    String query =
        "select value from AppProperty where property = '$propertyName'";
    var res = await db.rawQuery(query);
    var account = res[0]['value'].toString();
    return account;
  }

  Future<void> updateSelectedAccount({required String selectedAccount}) async {
    updateAppProperty(
        propertyName: selectedAccountProperty, propertyValue: selectedAccount);
    account = selectedAccount;
  }

  Future<void> updateAppProperty(
      {required String propertyName, required String propertyValue}) async {
    final db = await database;
    String query =
        "update AppProperty set value = '$propertyValue' where property = '$propertyName'";
    await db.rawUpdate(query);
  }

  // Future<List<Category>> getCategoriesByType(String type) async {
  //   final db = await database;
  //   String query = "select * from Categories where type = '$type' ";
  //   var res = await db.rawQuery(query);
  //   List<Category> list =
  //       res.isNotEmpty ? res.map((c) => Category.fromMap(c)).toList() : [];
  //   return list;
  // }

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

  deleteRecordById(int id) async {
    final db = await database;
    await db.rawQuery("DELETE FROM record where id = $id");
  }

  // Future<List<Record>> getAllRecords() async {
  //   final db = await database;
  //   var res = await db.query("Record");
  //   List<Record> list =
  //       res.isNotEmpty ? res.map((c) => Record.fromMap(c)).toList() : [];
  //   return list;
  // }

  //TODO change with account filter
  Future<List<Record>> getRecentRecords(int count) async {
    final db = await database;
    String query =
        "SELECT * FROM Record WHERE account = '$account' ORDER BY id DESC LIMIT 10";
    if (account == allAccountsName) {
      query = "SELECT * FROM Record ORDER BY id DESC LIMIT 10";
    }
    var res = await db.rawQuery(query);
    List<Record> list =
        res.isNotEmpty ? res.map((c) => Record.fromMap(c)).toList() : [];
    return list;
  }

  Future<Record> getRecordById(int id) async {
    final db = await database;
    String query = "SELECT * FROM Record WHERE id = $id";
    var res = await db.rawQuery(query);
    return Record.fromMap(res[0]);
  }

  Future<List<AutoFill>> getAllAutoFillRecords() async {
    final db = await database;
    var res = await db.query("Autofill");
    List<AutoFill> list =
        res.isNotEmpty ? res.map((c) => AutoFill.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Record>> getAllRecordsByDate(DateTime date) async {
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

  // Future<List<Record>> getAllRecordsBetweenDate(DateTime fromDate,
  //     [DateTime? toDate]) async {
  //   toDate ??= getTodaysDate();
  //   String query =
  //       "SELECT * FROM Record WHERE date BETWEEN '${fromDate.toString()}' AND '${toDate.toString()}' ";
  //   if (account != allAccountsName) {
  //     query += "AND account = '$account' ";
  //   }
  //   final db = await database;
  //   var res = await db.rawQuery(query);
  //   List<Record> list =
  //       res.isNotEmpty ? res.map((c) => Record.fromMap(c)).toList() : [];
  //   return list;
  // }

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

  Future<(int, int)> getTotalIncomeAndExpense(
      DateTime startDate, DateTime endDate) async {
    int totalIncome = await getTotalIncome(startDate, endDate);
    int totalExpense = await getTotalExpense(startDate, endDate);
    return (totalIncome, totalExpense);
  }

  Future<int> getTotalIncome(DateTime startDate, DateTime endDate) async {
    String incomeQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Income' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' ";
    final db = await database;
    List<Map<String, Object?>> totalIncomeRes = await db.rawQuery(incomeQuery);
    int totalIncome = (totalIncomeRes[0]['balance'] == null)
        ? 0
        : int.parse(totalIncomeRes[0]['balance'].toString());
    return totalIncome;
  }

  Future<int> getTotalExpense(DateTime startDate, DateTime endDate) async {
    String incomeQuery =
        "SELECT SUM(amount) as balance from Record where type = 'Expense' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' ";
    final db = await database;
    List<Map<String, Object?>> totalExpenseRes = await db.rawQuery(incomeQuery);
    int totalExpense = (totalExpenseRes[0]['balance'] == null)
        ? 0
        : int.parse(totalExpenseRes[0]['balance'].toString());
    return totalExpense;
  }

  Future<List<RecordDateGrouped>> getExpensesByDay(
      DateTime startDate, DateTime endDate) async {
    String incomeQuery =
        "SELECT date, type, SUM(amount) as balance from Record where type = 'Expense' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by date";
    final db = await database;
    List<Map<String, Object?>> res = await db.rawQuery(incomeQuery);
    List<RecordDateGrouped> list = res.isNotEmpty
        ? res.map((c) => RecordDateGrouped.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<List<RecordDateGrouped>> getIncomesByDay(
      DateTime startDate, DateTime endDate) async {
    String incomeQuery =
        "SELECT date, type, SUM(amount) as balance from Record where type = 'Income' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by date";
    final db = await database;
    List<Map<String, Object?>> res = await db.rawQuery(incomeQuery);
    List<RecordDateGrouped> list = res.isNotEmpty
        ? res.map((c) => RecordDateGrouped.fromMap(c)).toList()
        : [];
    return list;
  }

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

  Future<List<RecordDateGrouped>> getIncomesByMonth(
      DateTime startDate, DateTime endDate) async {
    String incomeQuery =
        "SELECT date, type, SUM(amount) as balance from Record where type = 'Income' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by date";
    final db = await database;
    List<Map<String, Object?>> res = await db.rawQuery(incomeQuery);
    List<RecordDateGrouped> list = res.isNotEmpty
        ? res.map((c) => RecordDateGrouped.fromMap(c)).toList()
        : [];
    return list;
  }

  Future<RecordsSummary> getCurrentMonthData() async {
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
    return RecordsSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        period: Period.month);
  }

  Future<RecordsSummary> getCurrentYearData() async {
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
    return RecordsSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        period: Period.year);
  }

  Future<RecordsSummary> getCurrentWeekData() async {
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

    return RecordsSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        period: Period.week);
  }

  Future<List<Map<String, Object?>>> getCatSubcatGroupedExpences(
      DateTime startDate, DateTime endDate) async {
    String query =
        "select category, sub_category, SUM(amount) as amount from Record where type = 'Expense' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by category, sub_category;";
    final db = await database;
    var res = await db.rawQuery(query);
    return res;
  }

  Future<List<Map<String, Object?>>> getCatSubcatGroupedIncomes(
      DateTime startDate, DateTime endDate) async {
    String query =
        "select category, sub_category, SUM(amount) as amount from Record where type = 'Income' AND date BETWEEN '${startDate.toString()}' AND '${endDate.toString()}' group by category;";
    final db = await database;
    var res = await db.rawQuery(query);
    return res;
  }

  Future<RecordsSummary> getTodaysData() async {
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
    return RecordsSummary(
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        period: Period.today);
  }

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

  Future<List<String>> getAppAccounts() async {
    final db = await database;
    String query = "select * from Accounts order by id DESC";
    List<Map<String, Object?>> res = await db.rawQuery(query);
    var accounts = res.map((entry) => entry['name'].toString()).toList();
    return accounts;
  }

  // deleteAccountAndRecords(String account) async {
  //   final db = await database;
  //   String query = "DELETE FROM Accounts where name = '$account' ";
  //   await db.rawDelete(query);
  //   query = "DELETE FROM record where account = '$account' ";
  //   await db.rawQuery(query);
  // }

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
}
