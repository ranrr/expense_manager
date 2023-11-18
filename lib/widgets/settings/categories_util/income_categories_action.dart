import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/category.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IncomeCategoryActions extends StatelessWidget {
  const IncomeCategoryActions({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IncomeCategoryNameEdit(category: category),
        IncomeCategoryDelete(category: category),
      ],
    );
  }
}

class IncomeCategoryDelete extends StatelessWidget {
  const IncomeCategoryDelete({
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
        var value = await showDialog<bool?>(
          context: context,
          builder: (BuildContext context) {
            return const DeleteIncomeCategoryAlert();
          },
        );
        if (value ?? false) {
          categoryProvider.setLoader(true);
          await DBProvider.db.deleteIncomeCategoryAndRecords(category);
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
        child: Icon(Icons.delete),
      ),
    );
  }
}

class IncomeCategoryNameEdit extends StatelessWidget {
  const IncomeCategoryNameEdit({
    super.key,
    required this.category,
  });

  final String category;

  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.read<Categories>();
    DashboardData dashboardProvider = context.read<DashboardData>();
    Map<String, List<Category>> incomeCategoriesMap =
        categoryProvider.incomeCategoriesMap ?? {};
    var incomeCategories = incomeCategoriesMap.keys.toList();
    return GestureDetector(
      onTap: () async {
        var newCategoryName = await showDialog<String?>(
          context: context,
          builder: (BuildContext context) {
            final catController = TextEditingController();
            catController.text = category;
            return EditIncomeCategoryNameAlert(catController: catController);
          },
        );
        if (newCategoryName != null &&
            newCategoryName.isNotEmpty &&
            newCategoryName != category) {
          if (incomeCategories.contains(newCategoryName)) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(
                    child: Text("Income category already exists."),
                  ),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(30),
                  shape: StadiumBorder(),
                  duration: Duration(milliseconds: 2000),
                ),
              );
            }
          } else {
            categoryProvider.setLoader(true);
            await DBProvider.db
                .renameIncomeCategoryAndRecords(category, newCategoryName);
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
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.edit),
      ),
    );
  }
}

class EditIncomeCategoryNameAlert extends StatelessWidget {
  const EditIncomeCategoryNameAlert({
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
          const Text('Enter new Category name'),
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
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: catController,
          builder: (context, value, child) {
            return TextButton(
              onPressed: value.text.isNotEmpty
                  ? () {
                      Navigator.pop(context, catController.text.trim());
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

class DeleteIncomeCategoryAlert extends StatelessWidget {
  const DeleteIncomeCategoryAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Category Delete'),
      content: const Text(
          'This will delete the category and all its transactions. Please confirm.'),
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
