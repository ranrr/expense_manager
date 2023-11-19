import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/util/confirm_alert.dart';
import 'package:expense_manager/widgets/util/input_alert.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
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
        IncomeCategoryEdit(category: category),
        IncomeCategoryDelete(category: category),
      ],
    );
  }
}

class IncomeCategoryEdit extends StatelessWidget {
  const IncomeCategoryEdit({
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
            return IncomeCategoryEditAlert(initialValue: category);
          },
        );
        if (newCategoryName != null &&
            newCategoryName.isNotEmpty &&
            newCategoryName != category) {
          var message = await categoryProvider.renameIncomeCategory(
              category, newCategoryName);
          await dashboardProvider.updateDashboard();
          showSnackBar(message);
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.edit),
      ),
    );
  }
}

class IncomeCategoryEditAlert extends StatelessWidget {
  const IncomeCategoryEditAlert({
    super.key,
    required this.initialValue,
  });

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
            return const IncomeCategoryDeleteAlert();
          },
        );
        if (value ?? false) {
          var message = await categoryProvider.deleteIncomeCategory(category);
          await dashboardProvider.updateDashboard();
          showSnackBar(message);
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.delete),
      ),
    );
  }
}

class IncomeCategoryDeleteAlert extends StatelessWidget {
  const IncomeCategoryDeleteAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ConfirmAlertDialog(
        header: categoryDeleteHeader, message: categoryDeleteMessage);
  }
}
