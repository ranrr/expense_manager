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
  bool? _loading;

  List<Category>? get categories => _categories ?? [];
  List<Category>? get expenceCategories => _expenceCategories ?? [];
  List<Category>? get incomeCategories => _incomeCategories ?? [];
  Map<String, List<Category>>? get expenseCategoriesMap =>
      _expenseCategoriesMap ?? {};
  Map<String, List<Category>>? get incomeCategoriesMap =>
      _incomeCategoriesMap ?? {};
  bool? get loading => _loading;

  Categories._();

  static final Categories provider = Categories._();

  init() async {
    _initializeCategories();
    print("***************CategoryProvider init Done... ***************");
  }

  updateCategories() async {
    await _initializeCategories();
    notifyListeners();
  }

  setLoader(bool loader) {
    _loading = loader;
    notifyListeners();
  }

  _initializeCategories() async {
    //TODO try catch
    _categories = await DBProvider.db.getCategories();
    _expenceCategories =
        categories!.where((e) => e.type == RecordType.expense.name).toList();
    _incomeCategories =
        categories!.where((e) => e.type == RecordType.income.name).toList();
    _expenseCategoriesMap =
        expenceCategories!.groupListsBy((element) => element.category);
    _incomeCategoriesMap =
        incomeCategories!.groupListsBy((element) => element.category);
  }
}
