import 'package:collection/collection.dart';
import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/model/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenceCategoryDisplay extends StatelessWidget {
  const ExpenceCategoryDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.watch<Categories>();
    Map<String, List<Category>> categories =
        categoryProvider.expenseCategoriesMap;
    var categoryKeys =
        categories.keys.sorted((a, b) => a.compareTo(b)).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Expense Category'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: categoryKeys.length,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          final expansionTileKey = GlobalKey();
          var category = categoryKeys[index];
          return ExpansionTile(
            key: expansionTileKey,
            onExpansionChanged: (value) {
              if (value) {
                _scrollToSelectedContent(expansionTileKey);
              }
            },
            title: Padding(
              padding: const EdgeInsets.fromLTRB(55, 0, 0, 0),
              child: Text(category),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: categories[category]!.length,
                itemBuilder: (BuildContext context, int i) {
                  var subCategories = categories[category]!
                      .sorted((a, b) => a.subCategory.compareTo(b.subCategory));
                  var subCategory = subCategories[i];
                  return ListTile(
                    onTap: () => Navigator.pop(
                        context, "$category,${subCategory.subCategory}"),
                    title: Center(
                      child: Text(subCategory.subCategory),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

void _scrollToSelectedContent(GlobalKey expansionTileKey) {
  final keyContext = expansionTileKey.currentContext;
  if (keyContext != null) {
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      Scrollable.ensureVisible(keyContext,
          duration: const Duration(milliseconds: 200));
    });
  }
}
