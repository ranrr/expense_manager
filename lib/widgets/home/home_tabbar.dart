import 'package:flutter/material.dart';

class HomeTabBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeTabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const TabBar(
      tabs: <Widget>[
        Tab(
          icon: Icon(
            Icons.summarize,
            size: 40,
          ),
        ),
        Tab(
          icon: Icon(
            Icons.insights,
            size: 40,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
