import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentBalance extends StatelessWidget {
  final int balance;
  const CurrentBalance({required this.balance, super.key});

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('#,##,##0');
    var displayBalance = formatter.format(balance);
    return Card(
      elevation: 5,
      shadowColor: Colors.black,
      margin: const EdgeInsets.fromLTRB(8, 18, 8, 0),
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Current Balance",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "₹ $displayBalance",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
