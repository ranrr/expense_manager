import 'package:flutter/material.dart';

class SettingsLoader extends StatelessWidget {
  const SettingsLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
