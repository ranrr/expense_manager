import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/category.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class Categories with ChangeNotifier {
  late List<Category> categories = [];
  late List<Category> expenceCategories = [];
  late List<Category> incomeCategories = [];

  Map<String, List<String>> expenseCategoriesMap = {};
  Map<String, List<String>> incomeCategoriesMap = {};

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

  _initializeCategories() async {
    List<Category> categoriesFromDB = await DBProvider.db.getCategories();
    categories.addAll(categoriesFromDB);
    expenceCategories.addAll(
        categories.where((e) => e.type == RecordType.expense.name).toList());
    incomeCategories.addAll(
        categories.where((e) => e.type == RecordType.income.name).toList());
    _updateCategoriesMap();
  }

  _updateCategoriesMap() {
    for (var cat in expenceCategories) {
      var l = expenseCategoriesMap[cat.category];
      if (l == null) {
        expenseCategoriesMap[cat.category] = [cat.subCategory];
      } else {
        l.add(cat.subCategory);
      }
    }

    for (var cat in incomeCategories) {
      var l = incomeCategoriesMap[cat.category];
      if (l == null) {
        incomeCategoriesMap[cat.category] = [cat.subCategory];
      } else {
        l.add(cat.subCategory);
      }
    }
  }
}
