import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.add),
        ),
        EditCategoryName(category: category),
        DeleteCategoryName(category: category),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(Icons.arrow_drop_down_sharp),
        ),
      ],
    );
  }
}

class DeleteCategoryName extends StatelessWidget {
  const DeleteCategoryName({
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
        var confirmDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return const DeleteCategoryAlert();
          },
        );
        if (confirmDelete != null && confirmDelete) {
          await DBProvider.db.deleteExpenseCategoryAndRecords(category);
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
          await categoryProvider.updateCategories();
          await dashboardProvider.updateDashboard();
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.delete_outlined),
      ),
    );
  }
}

class EditCategoryName extends StatelessWidget {
  const EditCategoryName({
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
        var newCategoryName = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            final catController = TextEditingController();
            catController.text = category;
            return EditCategoryAlert(catController: catController);
          },
        );
        if (newCategoryName != null &&
            newCategoryName.isNotEmpty &&
            newCategoryName != category) {
          await DBProvider.db
              .renameExpenseCategoryAndRecords(category, newCategoryName);
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
          await categoryProvider.updateCategories();
          await dashboardProvider.updateDashboard();
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.edit_outlined),
      ),
    );
  }
}

class EditCategoryAlert extends StatelessWidget {
  const EditCategoryAlert({
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

class DeleteCategoryAlert extends StatelessWidget {
  const DeleteCategoryAlert({
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
