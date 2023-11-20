import 'package:flutter/material.dart';

//model to hold the search filter criteria in custom period report scene
class CustomPeriodFilter {
  DateTime startDate;
  DateTime endDate;
  bool recordsOnly; // show transactions only flag
  String? category;
  String? subCategory;

  CustomPeriodFilter.init({
    this.category,
    this.subCategory,
  })  : startDate =
            DateUtils.addDaysToDate(DateUtils.dateOnly(DateTime.now()), -6),
        endDate = DateUtils.dateOnly(DateTime.now()),
        recordsOnly = false;

  @override
  String toString() {
    return 'CustomPeriodFilter(startDate: $startDate, endDate: $endDate, recordsOnly: $recordsOnly, category: $category, subCategory: $subCategory)';
  }

  @override
  bool operator ==(covariant CustomPeriodFilter other) {
    //return false as default to trigger rebuild when the object of type 'CustomPeriodFilter' changes in the provider
    return false;
  }

  @override
  int get hashCode {
    return startDate.hashCode ^
        endDate.hashCode ^
        recordsOnly.hashCode ^
        category.hashCode ^
        subCategory.hashCode;
  }
}
