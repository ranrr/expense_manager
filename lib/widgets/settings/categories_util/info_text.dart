import 'package:flutter/material.dart';

class CategorySettingsInfoText extends StatelessWidget {
  const CategorySettingsInfoText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 0, 0, 20),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Category delete will delete transactions too."),
          Text("Category rename will rename transactions too."),
        ],
      ),
    );
  }
}
