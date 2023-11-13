import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubCategoryActions extends StatelessWidget {
  final String category;
  final String subCategory;
  const SubCategoryActions({
    required this.category,
    required this.subCategory,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        EditSubCategoryName(
          category: category,
          subCategory: subCategory,
        ),
        DeleteSubCategoryName(
          category: category,
          subCategory: subCategory,
        ),
      ],
    );
  }
}

class DeleteSubCategoryName extends StatelessWidget {
  final String category;
  final String subCategory;
  const DeleteSubCategoryName({
    required this.category,
    required this.subCategory,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.read<Categories>();
    DashboardData dashboardProvider = context.read<DashboardData>();
    return GestureDetector(
      onTap: () async {
        var confirmDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return const DeleteSubCategoryAlert();
          },
        );
        if (confirmDelete != null && confirmDelete) {
          await DBProvider.db
              .deleteSubCategoryAndRecords(category, subCategory);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(
                  child: Text("Sub-Category deleted."),
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
        child: Icon(Icons.delete_outline),
      ),
    );
  }
}

class EditSubCategoryName extends StatelessWidget {
  final String category;
  final String subCategory;
  const EditSubCategoryName({
    required this.category,
    required this.subCategory,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.read<Categories>();
    DashboardData dashboardProvider = context.read<DashboardData>();
    return GestureDetector(
      onTap: () async {
        var newSubCategoryName = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            final subcatController = TextEditingController();
            subcatController.text = subCategory;
            return EditSubCategoryAlert(subcatController: subcatController);
          },
        );
        if (newSubCategoryName != null &&
            newSubCategoryName.isNotEmpty &&
            newSubCategoryName != subCategory) {
          await DBProvider.db.renameSubCategoryAndRecords(
              category, subCategory, newSubCategoryName);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Center(
                  child: Text("Sub-Category renamed."),
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

class EditSubCategoryAlert extends StatelessWidget {
  const EditSubCategoryAlert({
    super.key,
    required this.subcatController,
  });

  final TextEditingController subcatController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Sub-Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter new sub category name'),
          TextFormField(
            controller: subcatController,
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, ''),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, subcatController.text.trim()),
          child: const Text('OK'),
        ),
      ],
    );
  }
}

class DeleteSubCategoryAlert extends StatelessWidget {
  const DeleteSubCategoryAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Sub-Category Delete'),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('This will delete sub-category name and all transactions.'),
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
