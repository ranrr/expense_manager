import 'package:flutter/material.dart';

class EmptyChart extends StatelessWidget {
  const EmptyChart({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 40),
      child: Center(
        child: Text(
          "No Transactions",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
