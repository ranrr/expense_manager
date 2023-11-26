import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/record_entry/category_exp_display.dart';
import 'package:expense_manager/widgets/record_entry/category_inc_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySelect extends StatelessWidget {
  const CategorySelect({
    required this.categoryText,
    super.key,
  });
  final String categoryText;

  @override
  Widget build(BuildContext context) {
    var recordProvider = context.read<RecordProvider>();
    print('**********************category build');

    final catController = TextEditingController();
    // String? text;
    // if (recordProvider.category.isEmpty) {
    //   text = '';
    // } else if (recordType == RecordType.expense.name) {
    //   text = "${recordProvider.category} | ${recordProvider.subCategory}";
    // } else if (recordType == RecordType.income.name) {
    //   text = recordProvider.category;
    // }
    catController.text = categoryText;

    return TextFormField(
      controller: catController,
      readOnly: true,
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute<String>(
            builder: (BuildContext context) {
              if (recordProvider.recordType == RecordType.expense.name) {
                return const ExpenceCategoryDisplay();
              } else {
                return const IncomeCategoryDisplay();
              }
            },
          ),
        );
        if (result != null) {
          recordProvider.setCategory(result);
        }
      },
      decoration:
          recordFormDecoration(text: "Category", iconData: Icons.category),
    );
  }
}
