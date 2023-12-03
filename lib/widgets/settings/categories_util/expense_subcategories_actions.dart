import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/util/confirm_alert.dart';
import 'package:expense_manager/widgets/util/input_alert.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseSubCategoryActions extends StatelessWidget {
  final String category;
  final String subCategory;
  const ExpenseSubCategoryActions({
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
        EditExpenseSubCategory(
          category: category,
          subCategory: subCategory,
        ),
        DeleteExpenseSubCategory(
          category: category,
          subCategory: subCategory,
        ),
      ],
    );
  }
}

class EditExpenseSubCategory extends StatelessWidget {
  final String category;
  final String subCategory;
  const EditExpenseSubCategory({
    required this.category,
    required this.subCategory,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Categories categoryProvider = context.read<Categories>();
    DashboardData dashboardProvider = context.read<DashboardData>();
    var chartProvider = context.read<RefreshCharts>();
    return GestureDetector(
      onTap: () async {
        var newSubCategoryName = await showDialog<String?>(
          context: context,
          builder: (BuildContext context) {
            return EditExpenseSubCategoryAlert(initialValue: subCategory);
          },
        );
        if (newSubCategoryName != null &&
            newSubCategoryName.isNotEmpty &&
            newSubCategoryName != subCategory) {
          var message = await categoryProvider.renameExpenseSubCategory(
              category, subCategory, newSubCategoryName);
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

class EditExpenseSubCategoryAlert extends StatelessWidget {
  const EditExpenseSubCategoryAlert({
    super.key,
    required this.initialValue,
  });

  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return InputAlertDialog(
      header: subCategoryRenameHeader,
      message: subCategoryRenameMessage,
      initialValue: initialValue,
    );
  }
}

class DeleteExpenseSubCategory extends StatelessWidget {
  final String category;
  final String subCategory;
  const DeleteExpenseSubCategory({
    required this.category,
    required this.subCategory,
    super.key,
  });

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
            return const DeleteExpenseSubCategoryAlert();
          },
        );
        if (confirmDelete ?? false) {
          var message = await categoryProvider.deleteExpenseSubCategory(
              category, subCategory);
          await dashboardProvider.updateDashboard();
          await chartProvider.refresh();
          showSnackBar(message);
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.delete_outline),
      ),
    );
  }
}

class DeleteExpenseSubCategoryAlert extends StatelessWidget {
  const DeleteExpenseSubCategoryAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ConfirmAlertDialog(
        header: subCategoryDeleteHeader, message: subCategoryDeleteMessage);
  }
}
