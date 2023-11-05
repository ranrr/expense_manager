import 'package:flutter/material.dart';

class PeriodReportDivider extends StatelessWidget {
  final String text;
  const PeriodReportDivider({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 8, 15, 0),
      child: Card(
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
