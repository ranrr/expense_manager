import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/record.dart';
import 'package:expense_manager/widgets/util/loader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardData = context.watch<DashboardData>();
    var records = dashboardData.records ?? [];
    return Expanded(
      child: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.fromLTRB(8, 5, 8, 0),
            child: ListTile(
              // isThreeLine: true,
              title: Text(records[index].toString()),
              // subtitle: Padding(
              //   padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              //   child: Text("test"),
              // ),
            ),
          );
        },
      ),
    );

    //TODO remove old commented code
    /* return FutureBuilder<List<Record>>(
      future: DBProvider.db.getRecentRecords(10),
      builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
        Widget widget;
        if (snapshot.hasData) {
          List<Record> records = snapshot.data!;
          widget = Expanded(
            child: ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.fromLTRB(8, 5, 8, 0),
                  child: ListTile(
                    // isThreeLine: true,
                    title: Text(records[index].toString()),
                    // subtitle: Padding(
                    //   padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    //   child: Text("test"),
                    // ),
                  ),
                );
              },
            ),
          );
        } else if (snapshot.hasError) {
          widget = Container();
        } else {
          widget = const Loader();
        }
        return widget;
      },
    ); */
  }
}
