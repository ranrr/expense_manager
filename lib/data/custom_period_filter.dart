import 'package:flutter/material.dart';

class CustomPeriodFilter {
  DateTime startDate;
  DateTime endDate;
  bool recordsOnly;
  String? category;
  String? subCategory;

  CustomPeriodFilter({
    required this.startDate,
    required this.endDate,
    required this.recordsOnly,
    this.category,
    this.subCategory,
  });

  CustomPeriodFilter.init({
    this.category,
    this.subCategory,
  })  : startDate =
            DateUtils.addDaysToDate(DateUtils.dateOnly(DateTime.now()), -6),
        endDate = DateUtils.dateOnly(DateTime.now()),
        recordsOnly = false;

  CustomPeriodFilter.initWithFilter(
    this.startDate,
    this.endDate,
    this.recordsOnly, {
    this.category,
    this.subCategory,
  });

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
