import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateText extends StatelessWidget {
  final DateTime date;
  const DateText({required this.date, super.key});

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = DateFormat('MMM');
    String monthAbbr = formatter.format(date);
    var datetext = "${date.day} - $monthAbbr - ${date.year}";
    return Text(
      datetext,
      style: const TextStyle(fontSize: 16),
    );
  }
}
