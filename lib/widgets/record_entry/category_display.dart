import 'package:expense_manager/data/category_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryDisplay extends StatelessWidget {
  const CategoryDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryProvider categoryProvider = context.watch<CategoryProvider>();
    Map<String, List<String>> categories =
        categoryProvider.expenseCategoriesMap;
    var categoryKeys = categories.keys.toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Category'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: categoryKeys.length,
        itemBuilder: (BuildContext context, int index) {
          var category = categoryKeys[index];
          return ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(55, 0, 0, 0),
              child: Text(category),
            ),
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: categories[category]!.length,
                itemBuilder: (BuildContext context, int i) {
                  var subCategories = categories[category]!;
                  var subCategory = subCategories[i];
                  return ListTile(
                    onTap: () =>
                        Navigator.pop(context, "$category,$subCategory"),
                    title: Center(
                      child: Text(subCategory),
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
