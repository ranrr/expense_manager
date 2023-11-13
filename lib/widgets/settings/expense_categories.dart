import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/model/category.dart';
import 'package:expense_manager/widgets/settings/categories_util/categories_actions.dart';
import 'package:expense_manager/widgets/settings/categories_util/sub_categories_actions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseCategoriesSettings extends StatefulWidget {
  const ExpenseCategoriesSettings({
    super.key,
  });

  @override
  State<ExpenseCategoriesSettings> createState() =>
      _ExpenseCategoriesSettingsState();
}

class _ExpenseCategoriesSettingsState extends State<ExpenseCategoriesSettings> {
  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.watch<Categories>();
    Map<String, List<Category>> expenseCategories =
        categoryProvider.expenseCategoriesMap ?? {};
    var categoryKeys = expenseCategories.keys.toList();
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 0, 20),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Category delete will delete transactions also."),
              Text("Category rename will rename transactions also."),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: categoryKeys.length,
          physics: const ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            final expansionTileKey = GlobalKey();
            var category = categoryKeys[index];
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              child: Card(
                child: ExpansionTile(
                  key: expansionTileKey,
                  onExpansionChanged: (value) {
                    if (value) {
                      _scrollToSelectedContent(expansionTileKey);
                    }
                  },
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                    child: Text(category),
                  ),
                  trailing: CategoryActions(category: category),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: expenseCategories[category]!.length,
                      itemBuilder: (BuildContext context, int i) {
                        var subCategories = expenseCategories[category]!;
                        var subCategory = subCategories[i];
                        return ListTile(
                          trailing: SubCategoryActions(
                            category: category,
                            subCategory: subCategory.subCategory,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(subCategory.subCategory),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
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
