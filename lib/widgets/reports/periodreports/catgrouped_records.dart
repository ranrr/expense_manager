import 'package:expense_manager/data/period_report_provider.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryGroupedRecords extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final RecordType recordType;
  const CategoryGroupedRecords(
      {required this.startDate,
      required this.endDate,
      required this.recordType,
      super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.read<PeriodReportProvider>();
    return FutureBuilder<Map<String, List<Map<String, Object?>>>>(
      //TODO change this to model
      future: getGroupedRecords(recordType, startDate, endDate),
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, List<Map<String, Object?>>>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          var data = snapshot.data!;
          var keys = snapshot.data!.keys;
          if (keys.isEmpty) {
            widget = const Padding(
              padding: EdgeInsets.fromLTRB(28, 10, 0, 10),
              child: Text(
                "No Transactions",
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            widget = ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: keys.length,
              itemBuilder: (BuildContext context, int index) {
                String category = keys.elementAt(index);
                List<Map<String, Object?>> categoryData = data[category]!;
                int catTotalAmount = categoryData.fold(
                    0,
                    (previousValue, element) =>
                        previousValue +
                        int.parse(element['amount'].toString()));
                return ExpansionTile(
                  shape: const Border(),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    (recordType.name == RecordType.expense.name)
                                        ? Colors.red
                                        : Colors.green,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 6,
                                minHeight: 6,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(category),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(catTotalAmount.toString()),
                      ),
                    ],
                  ),
                  children: List<Widget>.generate(
                    categoryData.length,
                    (index) {
                      return GestureDetector(
                        onTap: () {
                          print("clicked...");
                          print(category);
                          print(categoryData[index]['sub_category'].toString());
                          var subCategory =
                              categoryData[index]['sub_category'].toString();
                          provider.updateCustomPeriod(startDate, endDate,
                              recordsonly: true,
                              category: category,
                              subCategory: subCategory);

                          DefaultTabController.of(context)
                              .animateTo(Period.custom.indx);
                        },
                        child: Card(
                          margin: const EdgeInsets.fromLTRB(35, 0, 10, 5),
                          child: ListTile(
                              title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(categoryData[index]['sub_category']
                                  .toString()),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 39, 0),
                                child: Text(
                                    categoryData[index]['amount'].toString()),
                              ),
                            ],
                          )),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        } else if (snapshot.hasError) {
          widget = Container();
        } else {
          widget = Container();
        }
        return widget;
      },
    );
  }
}
