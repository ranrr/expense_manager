import 'package:flutter/material.dart';

class AppbarSettingsGearIcon extends StatelessWidget {
  const AppbarSettingsGearIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {},
        child: const Icon(
          Icons.settings,
          size: 25,
        ),
      ),
    );
  }
}
