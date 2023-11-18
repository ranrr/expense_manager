import 'package:expense_manager/data/category_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/category.dart';
import 'package:expense_manager/widgets/settings/categories_util/income_categories_action.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO move logic to provider
class IncomeCategoriesSettings extends StatelessWidget {
  const IncomeCategoriesSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // context.watch<Categories>();
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: const [
        InfoText(),
        AddIncomeCategoryRow(),
        IncomeCategoriesSettingsList()
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
        if (provider.loading ?? false)
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            ),
          ),
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
    //watch - because the categories list should be updated after edit or delete action
    Categories provider = context.watch<Categories>();
    var incomeCategories = provider.incomeCategories ?? [];
    var categories = incomeCategories.map((e) => e.category).toList();
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 35, 10),
      child: ElevatedButton(
        onPressed: () async {
          var newIncomeCategoryName = await showDialog<String?>(
            context: context,
            builder: (BuildContext context) {
              final catController = TextEditingController();
              return AddIncomeCategoryAlert(catController: catController);
            },
          );
          if (newIncomeCategoryName != null) {
            if (categories.contains(newIncomeCategoryName)) {
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
              provider.setLoader(true);
              await DBProvider.db.addNewIncomeCategory(
                  newIncomeCategoryName, newIncomeCategoryName);
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

class AddIncomeCategoryAlert extends StatelessWidget {
  const AddIncomeCategoryAlert({
    super.key,
    required this.catController,
  });

  final TextEditingController catController;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Income Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Enter Category Name'),
          TextFormField(
            controller: catController,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
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

class IncomeCategoriesSettingsList extends StatelessWidget {
  const IncomeCategoriesSettingsList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //watch - because the list should be refreshed on action
    Categories categoryProvider = context.watch<Categories>();
    Map<String, List<Category>> incomeCategoriesMap =
        categoryProvider.incomeCategoriesMap ?? {};
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
