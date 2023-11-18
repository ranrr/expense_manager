import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO move logic to provider
class CategoryActions extends StatelessWidget {
  const CategoryActions({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        AddExpenseSubCategory(category: category),
        EditExpenseCategoryName(category: category),
        DeleteExpenseCategory(category: category),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.arrow_drop_down_sharp),
        ),
      ],
    );
  }
}

class AddExpenseSubCategory extends StatelessWidget {
  const AddExpenseSubCategory({
    required this.category,
    super.key,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    Categories provider = context.read<Categories>();
    Map<String, List<Category>> expenseCategories =
        provider.expenseCategoriesMap ?? {};
    var subCategories =
        expenseCategories[category]!.map((e) => e.subCategory).toList();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          var newSubCategoryName = await showDialog<String?>(
            context: context,
            builder: (BuildContext context) {
              final subCatController = TextEditingController();
              return AlertDialog(
                title: const Text('Add Sub-Category'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    valueListenable: subCatController,
                    builder: (context, value, child) {
                      return TextButton(
                        onPressed: value.text.isNotEmpty
                            ? () {
                                Navigator.pop(
                                    context, (subCatController.text.trim()));
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
          if (newSubCategoryName != null) {
            if (subCategories.contains(newSubCategoryName)) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(
                      child: Text("Sub-Category already exists."),
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
              await DBProvider.db
                  .addNewExpenseCategory(category, newSubCategoryName);
              await provider.updateCategoriesAndStopLoader();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(
                      child: Text("Sub-Category added."),
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
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DeleteExpenseCategory extends StatelessWidget {
  const DeleteExpenseCategory({
    super.key,
    required this.category,
  });
  final String category;

  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.read<Categories>();
    DashboardData dashboardProvider = context.read<DashboardData>();
    return GestureDetector(
      onTap: () async {
        var confirmDelete = await showDialog<bool?>(
          context: context,
          builder: (BuildContext context) {
            return const DeleteExpenseCategoryAlert();
          },
        );
        if (confirmDelete != null && confirmDelete) {
          categoryProvider.setLoader(true);
          await DBProvider.db.deleteExpenseCategoryAndRecords(category);
          await categoryProvider.updateCategoriesAndStopLoader();
          await dashboardProvider.updateDashboard();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(
                  child: Text("Category deleted."),
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(30),
                shape: StadiumBorder(),
                duration: Duration(milliseconds: 2000),
              ),
            );
          }
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.delete_outlined),
      ),
    );
  }
}

class EditExpenseCategoryName extends StatelessWidget {
  const EditExpenseCategoryName({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.read<Categories>();
    DashboardData dashboardProvider = context.read<DashboardData>();
    return GestureDetector(
      onTap: () async {
        var newCategoryName = await showDialog<String?>(
          context: context,
          builder: (BuildContext context) {
            final catController = TextEditingController();
            catController.text = category;
            return EditExpenseCategoryAlert(catController: catController);
          },
        );
        if (newCategoryName != null &&
            newCategoryName.isNotEmpty &&
            newCategoryName != category) {
          categoryProvider.setLoader(true);
          await DBProvider.db
              .renameExpenseCategoryAndRecords(category, newCategoryName);
          await categoryProvider.updateCategoriesAndStopLoader();
          await dashboardProvider.updateDashboard();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(
                  child: Text("Category renamed."),
                ),
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(30),
                shape: StadiumBorder(),
                duration: Duration(milliseconds: 2000),
              ),
            );
          }
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.edit_outlined),
      ),
    );
  }
}

class EditExpenseCategoryAlert extends StatelessWidget {
  const EditExpenseCategoryAlert({
    super.key,
    required this.catController,
  });

  final TextEditingController catController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter new category name'),
          TextFormField(
            controller: catController,
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, ''),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, catController.text.trim()),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class DeleteExpenseCategoryAlert extends StatelessWidget {
  const DeleteExpenseCategoryAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Category Delete'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This will delete category name and all transactions.'),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
