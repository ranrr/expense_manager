import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/widgets/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeTabs extends StatelessWidget {
  const HomeTabs({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: <Widget>[
        ChangeNotifierProvider(
          create: (context) => DashboardData.init(),
          child: const Dashboard(),
        ),
        const Center(
          child: Text("It's rainy here"),
        ),
      ],
    );
  }
}
