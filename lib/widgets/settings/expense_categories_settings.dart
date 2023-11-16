import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/category.dart';
import 'package:expense_manager/widgets/settings/categories_util/expense_categories_actions.dart';
import 'package:expense_manager/widgets/settings/categories_util/expense_subcategories_actions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO move logic to provider
class ExpenseCategoriesSettings extends StatelessWidget {
  const ExpenseCategoriesSettings({
    super.key,
  });

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
        const InfoText(),
        const AddExpenseCategoryRow(),
        ExpenseCategoriesListWithActions(
            categoryKeys: categoryKeys, expenseCategories: expenseCategories),
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  const InfoText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 0, 0, 20),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category delete will delete transactions too."),
          Text("Category rename will rename transactions too."),
        ],
      ),
    );
  }
}

class AddExpenseCategoryRow extends StatelessWidget {
  const AddExpenseCategoryRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //watch - should be rebuilt to show the loader
    var provider = context.watch<Categories>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (provider.loading ?? false)
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          ),
        const AddExpenseCategoryButton(),
      ],
    );
  }
}

class AddExpenseCategoryButton extends StatelessWidget {
  const AddExpenseCategoryButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Categories provider = context.watch<Categories>();
    Map<String, List<Category>> expenseCategories =
        provider.expenseCategoriesMap ?? {};
    var categories = expenseCategories.keys.toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 35, 10),
      child: ElevatedButton(
        onPressed: () async {
          var newCategoryName = await showDialog<(String, String)>(
            context: context,
            builder: (BuildContext context) {
              final catController = TextEditingController();
              final subCatController = TextEditingController();
              final validateController = TextEditingController();
              catController.addListener(() {
                if (catController.text.isNotEmpty &&
                    subCatController.text.isNotEmpty) {
                  validateController.text = 'true';
                } else {
                  validateController.text = '';
                }
              });
              subCatController.addListener(() {
                if (catController.text.isNotEmpty &&
                    subCatController.text.isNotEmpty) {
                  validateController.text = 'true';
                } else {
                  validateController.text = '';
                }
              });

              return AlertDialog(
                title: const Text('Add Expense Category'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Enter Category Name'),
                    TextFormField(
                      controller: catController,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text('Enter Sub-Category Name'),
                    ),
                    TextFormField(
                      controller: subCatController,
                    )
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  //
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: validateController,
                    builder: (context, value, child) {
                      return TextButton(
                        onPressed: value.text.isNotEmpty
                            ? () {
                                Navigator.pop(context, (
                                  catController.text.trim(),
                                  subCatController.text.trim()
                                ));
                              }
                            : null,
                        child: const Text('OK'),
                      );
                    },
                  ),
                ],
              );
            },
          );
          if (newCategoryName != null) {
            String category = newCategoryName.$1;
            String subCategory = newCategoryName.$2;
            if (categories.contains(category)) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(
                      child: Text("Expense category already exists."),
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(30),
                    shape: StadiumBorder(),
                    duration: Duration(milliseconds: 2000),
                  ),
                );
              }
            } else {
              provider.setLoader(true);
              await DBProvider.db.addNewExpenseCategory(category, subCategory);
              await provider.updateCategoriesAndStopLoader();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(
                      child: Text("Category added."),
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.all(30),
                    shape: StadiumBorder(),
                    duration: Duration(milliseconds: 2000),
                  ),
                );
              }
            }
          }
        },
        child: const Text("Add Category"),
      ),
    );
  }
}

class ExpenseCategoriesListWithActions extends StatelessWidget {
  const ExpenseCategoriesListWithActions({
    super.key,
    required this.categoryKeys,
    required this.expenseCategories,
  });

  final List<String> categoryKeys;
  final Map<String, List<Category>> expenseCategories;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: categoryKeys.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        final expansionTileKey = GlobalKey();
        var category = categoryKeys[index];
        var subCategories = expenseCategories[category]!;
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
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Text(category),
              ),
              trailing: CategoryActions(category: category),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: subCategories.length,
                  itemBuilder: (BuildContext context, int i) {
                    var subCategory = subCategories[i];
                    return ListTile(
                      trailing: ExpenseSubCategoryActions(
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
