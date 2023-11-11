import 'package:expense_manager/widgets/settings/app_settins.dart';
import 'package:flutter/material.dart';

class AppbarSettingsGearIcon extends StatelessWidget {
  const AppbarSettingsGearIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AppSettings(),
            ),
          );
        },
        child: const Icon(
          Icons.settings,
          size: 25,
        ),
      ),
    );
  }
}
