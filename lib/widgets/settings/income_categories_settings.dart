import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/category.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/widgets/settings/categories_util/income_categories_action.dart';
import 'package:expense_manager/widgets/settings/categories_util/info_text.dart';
import 'package:expense_manager/widgets/util/input_alert.dart';
import 'package:expense_manager/widgets/util/settings_loader.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO move logic to provider
class IncomeCategoriesSettings extends StatelessWidget {
  const IncomeCategoriesSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 10),
      children: const [
        CategorySettingsInfoText(),
        AddIncomeCategoryRow(),
        IncomeCategoriesListWithActions()
      ],
    );
  }
}

class AddIncomeCategoryRow extends StatelessWidget {
  const AddIncomeCategoryRow({
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
        if (provider.loading ?? false) const SettingsLoader(),
        const AddIncomeCategoryButton(),
      ],
    );
  }
}

class AddIncomeCategoryButton extends StatelessWidget {
  const AddIncomeCategoryButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Categories provider = context.read<Categories>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 35, 10),
      child: ElevatedButton(
        onPressed: () async {
          var newIncomeCategoryName = await showDialog<String?>(
            context: context,
            builder: (BuildContext context) {
              return const AddIncomeCategoryAlert();
            },
          );
          if (newIncomeCategoryName != null &&
              newIncomeCategoryName.isNotEmpty) {
            var message =
                await provider.addNewIncomeCategory(newIncomeCategoryName);
            if (context.mounted) {
              showSnackBar(context, message);
            }
          }
        },
        child: const Text("Add Category"),
      ),
    );
  }
}

class AddIncomeCategoryAlert extends StatelessWidget {
  const AddIncomeCategoryAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const InputAlertDialog(
      header: incomeCategoryAddHeader,
      message: incomeCategoryAddMessage,
    );
  }
}

class IncomeCategoriesListWithActions extends StatelessWidget {
  const IncomeCategoriesListWithActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //watch - because the list should be refreshed upon action on income category
    Categories categoryProvider = context.watch<Categories>();
    Map<String, List<Category>> incomeCategoriesMap =
        categoryProvider.incomeCategoriesMap;
    var incomeCategories = incomeCategoriesMap.keys.toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: incomeCategories.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var category = incomeCategories[index];
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          child: Card(
            child: ListTile(
              leading: Text(
                category,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: IncomeCategoryActions(category: category),
            ),
          ),
        );
      },
    );
  }
}
