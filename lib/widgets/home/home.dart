import 'package:expense_manager/widgets/home/home_scaffold.dart';
import 'package:flutter/material.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: HomeScaffold(),
    );
  }
}
