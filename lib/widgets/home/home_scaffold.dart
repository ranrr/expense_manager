import 'package:expense_manager/widgets/home/appbar_gear.dart';
import 'package:expense_manager/widgets/home/appbar_search.dart';
import 'package:expense_manager/widgets/home/appbar_switchaccounts.dart';
import 'package:expense_manager/widgets/home/fab.dart';
import 'package:expense_manager/widgets/home/home_tabbar.dart';
import 'package:expense_manager/widgets/home/home_tabs.dart';
import 'package:flutter/material.dart';

class HomeScaffold extends StatelessWidget {
  const HomeScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Manager'),
        actions: const <Widget>[
          SearchWidget(),
          AppbarSwitchAccountsIcon(),
          AppbarSettingsGearIcon(),
        ],
        bottom: const HomeTabBar(),
      ),
      body: const HomeTabs(),
      floatingActionButton: const Fab(),
    );
  }
}
