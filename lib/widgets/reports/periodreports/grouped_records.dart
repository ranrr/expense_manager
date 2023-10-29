import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:expense_manager/model/record.dart';

class CategoryGroupedRecords extends StatelessWidget {
  final List<Record> records;

  const CategoryGroupedRecords({required this.records, super.key});

  @override
  Widget build(BuildContext context) {
    Map<String, List<Record>> expenseTypeGroupedRecords =
        groupByRecordType(records);

    Map<String, Map<String, List<Record>>> catSubCatGroupedExpenses =
        categoryGroupedRecords(
            expenseTypeGroupedRecords[RecordType.expense.name]!);

    var categoryKeys = catSubCatGroupedExpenses.keys;

    return Column(
      children: [],
    );
  }
}

class SubCategoryGroupedRecords extends StatelessWidget {
  final Map<String, List<Record>> records;

  const SubCategoryGroupedRecords({required this.records, super.key});

  @override
  Widget build(BuildContext context) {
    int incomeByCategory = getIncomeByCategory(records);
    int expenseByCategory = getExpenseByCategory(records);
    var subCategories = records.keys;
    return Column(
      children: [],
    );
  }
}
