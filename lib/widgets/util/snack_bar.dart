import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(message),
      ),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(30),
      // shape: const StadiumBorder(),
      duration: const Duration(milliseconds: 2000),
    ),
  );
}
