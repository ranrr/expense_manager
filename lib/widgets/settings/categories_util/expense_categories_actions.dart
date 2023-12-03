import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/util/confirm_alert.dart';
import 'package:expense_manager/widgets/util/input_alert.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseCategoryActions extends StatelessWidget {
  const ExpenseCategoryActions({super.key, required this.category});

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
  const AddExpenseSubCategory({required this.category, super.key});

  final String category;

  @override
  Widget build(BuildContext context) {
    //watch  because, the list shouldbe refreshed after adding sub-category
    Categories provider = context.watch<Categories>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () async {
          var newSubCategoryName = await showDialog<String?>(
            context: context,
            builder: (BuildContext context) {
              return const AddExpenseSubCategoryAlert();
            },
          );
          if (newSubCategoryName != null && newSubCategoryName.isNotEmpty) {
            var message = await provider.addNewExpenseSubCategory(
                category, newSubCategoryName);
            showSnackBar(message);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddExpenseSubCategoryAlert extends StatelessWidget {
  const AddExpenseSubCategoryAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return const InputAlertDialog(
        header: subCategoryAddHeader, message: subCategoryAddMessage);
  }
}

class DeleteExpenseCategory extends StatelessWidget {
  const DeleteExpenseCategory({super.key, required this.category});
  final String category;

  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.read<Categories>();
    DashboardData dashboardProvider = context.read<DashboardData>();
    var chartProvider = context.read<RefreshCharts>();
    return GestureDetector(
      onTap: () async {
        var confirmDelete = await showDialog<bool?>(
          context: context,
          builder: (BuildContext context) {
            return const DeleteExpenseCategoryAlert();
          },
        );
        if (confirmDelete ?? false) {
          var message = await categoryProvider.deleteExpenseCategory(category);
          await dashboardProvider.updateDashboard();
          await chartProvider.refresh();
          showSnackBar(message);
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.delete_outlined),
      ),
    );
  }
}

class DeleteExpenseCategoryAlert extends StatelessWidget {
  const DeleteExpenseCategoryAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConfirmAlertDialog(
        header: categoryDeleteHeader, message: categoryDeleteMessage);
  }
}

class EditExpenseCategoryName extends StatelessWidget {
  const EditExpenseCategoryName({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.read<Categories>();
    DashboardData dashboardProvider = context.read<DashboardData>();
    var chartProvider = context.read<RefreshCharts>();
    return GestureDetector(
      onTap: () async {
        var newCategoryName = await showDialog<String?>(
          context: context,
          builder: (BuildContext context) {
            return EditExpenseCategoryAlert(initialValue: category);
          },
        );
        if (newCategoryName != null &&
            newCategoryName.isNotEmpty &&
            newCategoryName != category) {
          var message = await categoryProvider.renameExpenseCategory(
              category, newCategoryName);
          await dashboardProvider.updateDashboard();
          await chartProvider.refresh();
          showSnackBar(message);
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
  const EditExpenseCategoryAlert({super.key, required this.initialValue});

  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return InputAlertDialog(
      header: categoryRenameHeader,
      message: categoryRenameMessage,
      initialValue: initialValue,
    );
  }
}
