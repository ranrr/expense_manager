import 'package:flutter/material.dart';

class ConfirmAlertDialog extends StatelessWidget {
  const ConfirmAlertDialog({
    required this.header,
    required this.message,
    super.key,
  });

  final String header;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Account Delete'),
      content: const Text(
          'This will delete the Account and all its transactions. Please confirm.'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
