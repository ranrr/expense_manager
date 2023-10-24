import 'package:expense_manager/widgets/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TabBarView(
      children: <Widget>[
        Dashboard(),
        Center(
          child: Text("It's rainy here"),
        ),
      ],
    );
  }
}
