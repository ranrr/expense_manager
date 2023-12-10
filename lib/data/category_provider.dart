import 'package:collection/collection.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/category.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

//provider for the expense and income categories
class Categories with ChangeNotifier {
  List<Category>? _categories;
  List<Category>? _expenceCategories;
  List<Category>? _incomeCategories;
  Map<String, List<Category>>? _expenseCategoriesMap;
  Map<String, List<Category>>? _incomeCategoriesMap;
  bool _loading = false;

  List<Category> get categories => _categories ?? [];
  List<Category> get expenceCategories => _expenceCategories ?? [];
  List<Category> get incomeCategories => _incomeCategories ?? [];
  Map<String, List<Category>> get expenseCategoriesMap =>
      _expenseCategoriesMap ?? {};
  Map<String, List<Category>> get incomeCategoriesMap =>
      _incomeCategoriesMap ?? {};
  bool get loading => _loading;

  Categories._();

  static final Categories provider = Categories._();

  init() async {
    await _initializeCategories();
    debugPrint("***************CategoryProvider init Done... ***************");
  }

  updateCategories() async {
    await _initializeCategories();
    notifyListeners();
  }

  updateCategoriesAndStopLoader() async {
    await _initializeCategories();
    setLoader(false);
    notifyListeners();
  }

  setLoader(bool loader) {
    _loading = loader;
    notifyListeners();
  }

  _initializeCategories() async {
    _categories = await DBProvider.db.getCategories();
    _expenceCategories =
        categories.where((e) => e.type == RecordType.expense.name).toList();
    _incomeCategories =
        categories.where((e) => e.type == RecordType.income.name).toList();
    _expenseCategoriesMap =
        expenceCategories.groupListsBy((element) => element.category);
    _incomeCategoriesMap =
        incomeCategories.groupListsBy((element) => element.category);
  }

  Future<String> addNewExpenseCategory(
      String category, String subCategory) async {
    String message;
    if (expenseCategoriesMap.keys.toList().contains(category)) {
      message = "Expense category already exists.";
    } else {
      setLoader(true);
      await DBProvider.db.addNewExpenseCategory(category, subCategory);
      await updateCategoriesAndStopLoader();
      message = "Category added.";
    }
    return message;
  }

  Future<String> addNewExpenseSubCategory(
      String category, String newSubCategoryName) async {
    var subCategories =
        expenseCategoriesMap[category]!.map((e) => e.subCategory).toList();
    String message;
    if (subCategories.contains(newSubCategoryName)) {
      message = "Sub-Category already exists.";
    } else {
      setLoader(true);
      await DBProvider.db.addNewExpenseCategory(category, newSubCategoryName);
      await updateCategoriesAndStopLoader();
      message = "Sub-Category added.";
    }
    return message;
  }

  Future<String> renameExpenseCategory(
      String category, String newCategoryName) async {
    String message;
    if (expenseCategoriesMap.keys.toList().contains(newCategoryName)) {
      message = "Expense category already exists.";
    } else {
      setLoader(true);
      await DBProvider.db
          .renameExpenseCategoryAndRecords(category, newCategoryName);
      await updateCategoriesAndStopLoader();
      message = "Category renamed.";
    }

    return message;
  }

  Future<String> renameExpenseSubCategory(String category,
      String oldSubCategoryName, String newSubCategoryName) async {
    String message;
    var subCategories =
        expenseCategoriesMap[category]!.map((e) => e.subCategory).toList();
    if (subCategories.contains(newSubCategoryName)) {
      message = "Sub-Category already exists.";
    } else {
      setLoader(true);
      await DBProvider.db.renameExpenseSubCategoryAndRecords(
          category, oldSubCategoryName, newSubCategoryName);
      await updateCategoriesAndStopLoader();
      message = "Sub-Category renamed.";
    }
    return message;
  }

  Future<String> deleteExpenseCategory(String category) async {
    String message = "Category deleted.";
    setLoader(true);
    await DBProvider.db.deleteExpenseCategoryAndRecords(category);
    await updateCategoriesAndStopLoader();
    return message;
  }

  Future<String> deleteExpenseSubCategory(
      String category, String subCategory) async {
    String message = "Sub-Category deleted.";
    setLoader(true);
    await DBProvider.db
        .deleteExpenseSubCategoryAndRecords(category, subCategory);
    await updateCategoriesAndStopLoader();
    return message;
  }

  Future<String> addNewIncomeCategory(String newIncomeCategoryName) async {
    var categories = incomeCategories.map((e) => e.category).toList();
    String message;
    if (categories.contains(newIncomeCategoryName)) {
      message = "Income category already exists.";
    } else {
      setLoader(true);
      await DBProvider.db
          .addNewIncomeCategory(newIncomeCategoryName, newIncomeCategoryName);
      await updateCategoriesAndStopLoader();
      message = "Category added.";
    }
    return message;
  }

  Future<String> renameIncomeCategory(
      String category, String newCategoryName) async {
    String message;
    var incomeCategories = incomeCategoriesMap.keys.toList();
    if (incomeCategories.contains(newCategoryName)) {
      message = "Income category already exists.";
    } else {
      setLoader(true);
      await DBProvider.db
          .renameIncomeCategoryAndRecords(category, newCategoryName);
      await updateCategoriesAndStopLoader();
      message = "Category renamed.";
    }

    return message;
  }

  Future<String> deleteIncomeCategory(String category) async {
    String message = "Category deleted.";
    setLoader(true);
    await DBProvider.db.deleteIncomeCategoryAndRecords(category);
    await updateCategoriesAndStopLoader();
    return message;
  }
}
