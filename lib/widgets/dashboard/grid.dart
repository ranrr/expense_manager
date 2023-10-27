import 'package:expense_manager/data/dashboard_provider.dart';
import 'package:expense_manager/widgets/dashboard/gridcard.dart';
import 'package:flutter/material.dart';

class DashboardGrid extends StatelessWidget {
  final DashboardData data;
  const DashboardGrid({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        GridView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 5),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
            mainAxisExtent: 105,
          ),
          itemBuilder: (ctx, i) {
            return DashboardGridCard(data: data.getDashboardSummary(i));
          },
        ),
      ],
    );
  }
}
