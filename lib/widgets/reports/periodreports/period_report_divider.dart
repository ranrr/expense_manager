import 'package:flutter/material.dart';

class PeriodReportDivider extends StatelessWidget {
  final String text;
  const PeriodReportDivider({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Card(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 22),
            ),
          ),
        ),
      ),
    );
  }
}
