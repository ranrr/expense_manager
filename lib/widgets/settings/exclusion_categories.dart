import 'package:expense_manager/data/refresh_charts.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:expense_manager/widgets/record_entry/category_exp_display.dart';
import 'package:expense_manager/widgets/record_entry/category_inc_display.dart';
import 'package:expense_manager/widgets/util/confirm_alert.dart';
import 'package:expense_manager/widgets/util/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExclusionCategories extends StatefulWidget {
  const ExclusionCategories({super.key});

  @override
  State<ExclusionCategories> createState() => _ExclusionCategoriesState();
}

late Function _refresh;

class _ExclusionCategoriesState extends State<ExclusionCategories> {
  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    _refresh = refresh;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 10),
      children: [
        const ExclusionCategoriesInfoText(),
        const ExcludeButtonRow(),
        FutureBuilder<List<String>>(
          future: getAllCategoryExclusions(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            Widget widget;
            if (snapshot.hasData) {
              List<String> data = snapshot.data!;
              widget = CategoryExclusionListWithActions(exclusions: data);
            } else {
              widget = Container();
            }
            return widget;
          },
        )
      ],
    );
  }
}

class ExclusionCategoriesInfoText extends StatelessWidget {
  const ExclusionCategoriesInfoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 0, 0, 20),
      child: const Text(
          "Income and Expense transactions of the categories excluded will not be used in the report charts. "),
    );
  }
}

class ExcludeButtonRow extends StatelessWidget {
  const ExcludeButtonRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 35, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: ExcludeExpenseButton(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: ExcludeIncomeButton(),
          ),
        ],
      ),
    );
  }
}

class ExcludeExpenseButton extends StatelessWidget {
  const ExcludeExpenseButton({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<RefreshCharts>();
    return ElevatedButton(
      onPressed: () async {
        var excludedCategory = await Navigator.push(
          context,
          MaterialPageRoute<String>(builder: (BuildContext context) {
            return const ExpenceCategoryDisplay();
          }),
        );
        if (excludedCategory != null) {
          bool duplicate = await checkDuplicateExclusion(excludedCategory);
          if (duplicate) {
            showSnackBar('Exclusion Exists');
          } else {
            await addCategoryExclusion(excludedCategory);
            _refresh(); //to refresh the exclusions list by rebuilding stateful widget
            await provider.refresh(); //to refresh charts
            showSnackBar('Exclusion Added');
          }
        }
      },
      child: const Text('Exclude Expense'),
    );
  }
}

class ExcludeIncomeButton extends StatelessWidget {
  const ExcludeIncomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<RefreshCharts>();
    return ElevatedButton(
      onPressed: () async {
        var excludedCategory = await Navigator.push(
          context,
          MaterialPageRoute<String>(builder: (BuildContext context) {
            return const IncomeCategoryDisplay();
          }),
        );
        if (excludedCategory != null) {
          bool duplicate = await checkDuplicateExclusion(excludedCategory);
          if (duplicate) {
            showSnackBar('Exclusion Exists');
          } else {
            await addCategoryExclusion(excludedCategory);
            _refresh(); //to refresh the exclusions list by rebuilding stateful widget
            await provider.refresh(); //to refresh charts
            showSnackBar('Exclusion Added');
          }
        }
      },
      child: const Text('Exclude Income'),
    );
  }
}

class CategoryExclusionListWithActions extends StatelessWidget {
  const CategoryExclusionListWithActions({
    super.key,
    required this.exclusions,
  });

  final List<String> exclusions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: exclusions.length,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        var categoryText = getExclusionText(exclusions[index]);
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
          child: Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      categoryText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ExclusionCategoryActions(category: exclusions[index]),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ExclusionCategoryActions extends StatelessWidget {
  const ExclusionCategoryActions({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExclusionCategoryDelete(category: category),
      ],
    );
  }
}

class ExclusionCategoryDelete extends StatelessWidget {
  const ExclusionCategoryDelete({super.key, required this.category});

  final String category;

  @override
  Widget build(BuildContext context) {
    var provider = context.read<RefreshCharts>();
    return GestureDetector(
      onTap: () async {
        var value = await showDialog<bool?>(
          context: context,
          builder: (BuildContext context) {
            return const ExclusionCategoryDeleteAlert();
          },
        );
        if (value ?? false) {
          await deleteCategoryExclusion(category);
          _refresh(); //to refresh the exclusions list by rebuilding stateful widget
          await provider.refresh();
          showSnackBar('Exclusion deleted.');
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.delete),
      ),
    );
  }
}

class ExclusionCategoryDeleteAlert extends StatelessWidget {
  const ExclusionCategoryDeleteAlert({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ConfirmAlertDialog(
        header: exclusionDeleteHeader, message: exclusionDeleteMessage);
  }
}

getExclusionText(String category) {
  List<String> categories = category.split(',');
  if (categories[0] == categories[1]) {
    return categories[1];
  } else {
    return '${categories[0]} | ${categories[1]}';
  }
}
