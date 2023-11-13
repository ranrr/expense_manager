// ignore_for_file: must_be_immutable

import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/model/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeCategoriesList extends StatefulWidget {
  const IncomeCategoriesList({
    super.key,
  });

  @override
  State<IncomeCategoriesList> createState() => _IncomeCategoriesListState();
}

class _IncomeCategoriesListState extends State<IncomeCategoriesList> {
  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.read<Categories>();
    Map<String, List<Category>> incomeCategories =
        categoryProvider.incomeCategoriesMap ?? {};
    var categoryKeys = incomeCategories.keys.toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categoryKeys.length,
      itemBuilder: (BuildContext context, int index) {
        var category = categoryKeys[index];
        return ExpansionTile(
          trailing: const SizedBox.shrink(),
          title: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(55, 0, 0, 0),
              child: Text(category),
            ),
          ),
        );
      },
    );
  }
}
