import 'package:collection/collection.dart';
import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/model/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeCategoryDisplay extends StatelessWidget {
  const IncomeCategoryDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.watch<Categories>();
    Map<String, List<Category>> categories =
        categoryProvider.incomeCategoriesMap;
    var categoryKeys =
        categories.keys.sorted((a, b) => a.compareTo(b)).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Income Category'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: categoryKeys.length,
        itemBuilder: (BuildContext context, int index) {
          var category = categoryKeys[index];
          return ExpansionTile(
            trailing: const SizedBox.shrink(),
            title: GestureDetector(
              onTap: () => Navigator.pop(context, "$category,$category"),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(55, 0, 0, 0),
                child: Text(category),
              ),
            ),
          );
        },
      ),
    );
  }
}
