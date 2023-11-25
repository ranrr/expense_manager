import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/model/category.dart';
import 'package:expense_manager/widgets/settings/categories_util/expense_categories_actions.dart';
import 'package:expense_manager/widgets/settings/categories_util/expense_subcategories_actions.dart';
import 'package:expense_manager/widgets/settings/categories_util/info_text.dart';
import 'package:expense_manager/widgets/util/settings_loader.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseCategoriesSettings extends StatelessWidget {
  const ExpenseCategoriesSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 10),
      children: const [
        CategorySettingsInfoText(),
        AddExpenseCategoryRow(),
        ExpenseCategoriesListWithActions(),
      ],
    );
  }
}

class AddExpenseCategoryRow extends StatelessWidget {
  const AddExpenseCategoryRow({super.key});

  @override
  Widget build(BuildContext context) {
    //watch - should be rebuilt to show the loader
    var provider = context.watch<Categories>();
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (provider.loading) const SettingsLoader(),
        const AddExpenseCategoryButton(),
      ],
    );
  }
}

class AddExpenseCategoryButton extends StatelessWidget {
  const AddExpenseCategoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    Categories provider = context.read<Categories>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 35, 10),
      child: ElevatedButton(
        onPressed: () async {
          //returns tuple of new category and sub-category
          var newCategoryName = await showDialog<(String?, String?)>(
            context: context,
            builder: (BuildContext context) {
              return const AddExpenseCategoryAlert();
            },
          );
          if (newCategoryName != null &&
              newCategoryName.$1 != null &&
              newCategoryName.$2 != null) {
            var message = await provider.addNewExpenseCategory(
                newCategoryName.$1!, newCategoryName.$2!);
            showSnackBar(message);
          }
        },
        child: const Text("Add Category"),
      ),
    );
  }
}

class ExpenseCategoriesListWithActions extends StatelessWidget {
  const ExpenseCategoriesListWithActions({super.key});

  @override
  Widget build(BuildContext context) {
    //watch - because the list must be refreshed with rebuild
    Categories categoryProvider = context.watch<Categories>();
    Map<String, List<Category>> expenseCategories =
        categoryProvider.expenseCategoriesMap;
    var categoryKeys = expenseCategories.keys.toList();
    //category list
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
              // category title
              title: ExpenseCategoryTitle(category: category),
              // category title actions
              trailing: ExpenseCategoryActions(category: category),
              //sub-categories list for category
              children: [
                ExpenseSubCategoryList(
                    subCategories: subCategories, category: category),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExpenseCategoryTitle extends StatelessWidget {
  const ExpenseCategoryTitle({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
      child: Text(category),
    );
  }
}

class ExpenseSubCategoryList extends StatelessWidget {
  const ExpenseSubCategoryList({
    super.key,
    required this.subCategories,
    required this.category,
  });

  final List<Category> subCategories;
  final String category;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: subCategories.length,
      itemBuilder: (BuildContext context, int i) {
        var subCategory = subCategories[i];
        return ListTile(
          //sub-category title
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(subCategory.subCategory),
            ],
          ),
          //sub-category actions
          trailing: ExpenseSubCategoryActions(
            category: category,
            subCategory: subCategory.subCategory,
          ),
        );
      },
    );
  }
}

class AddExpenseCategoryAlert extends StatelessWidget {
  const AddExpenseCategoryAlert({super.key});

  @override
  Widget build(BuildContext context) {
    final catController = TextEditingController();
    final subCatController = TextEditingController();
    //used to enable/disable ok button of alert dialog
    //modified in the listeners of category and sub-category controllers
    final validateController = TextEditingController();
    catController.addListener(() {
      if (catController.text.isNotEmpty && subCatController.text.isNotEmpty) {
        validateController.text = 'true';
      } else {
        validateController.text = '';
      }
    });
    subCatController.addListener(() {
      if (catController.text.isNotEmpty && subCatController.text.isNotEmpty) {
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
            maxLength: 20,
            controller: catController,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text('Enter Sub-Category Name'),
          ),
          TextFormField(
            maxLength: 20,
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
