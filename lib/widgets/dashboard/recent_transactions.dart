import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          return const Card(
            margin: EdgeInsets.fromLTRB(8, 5, 8, 0),
            child: ListTile(
              // isThreeLine: true,
              title: Text("Test"),
              // subtitle: Padding(
              //   padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
              //   child: Text("test"),
              // ),
            ),
          );
        },
      ),
    );
  }
}
