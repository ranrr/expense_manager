// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/category.dart';

class CategoryProvider with ChangeNotifier {
  late List<Category> categories = [];
  late List<Category> expenceCategories = [];
  late List<Category> incomeCategories = [];

  Map<String, List<String>> expenseCategoriesMap = {};
  Map<String, List<String>> incomeCategoriesMap = {};

  CategoryProvider.initWithCategories(List<Category> categoryList) {
    categories.addAll(categoryList);
    updateCategories();
  }

  CategoryProvider.init() {
    if (expenceCategories.isEmpty || incomeCategories.isEmpty) {
      initializeCategories();
    }
  }

  initializeCategories() async {
    categories.addAll(await DBProvider.db.getCategories());
    expenceCategories
        .addAll(categories.where((e) => e.type == "Expense").toList());
    incomeCategories
        .addAll(categories.where((e) => e.type == "Income").toList());
    updateCategories();
    notifyListeners();
  }

  updateCategories() {
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
