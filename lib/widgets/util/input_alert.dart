import 'package:flutter/material.dart';

class InputAlertDialog extends StatelessWidget {
  const InputAlertDialog({
    super.key,
    required this.header,
    required this.message,
    this.initialValue,
  });

  final String header;
  final String message;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    controller.text = initialValue ?? '';

    return AlertDialog(
      title: Text(header),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message),
          TextFormField(
            maxLength: 20,
            controller: controller,
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, ''),
          child: const Text('Cancel'),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            return TextButton(
              onPressed: value.text.isNotEmpty
                  ? () {
                      Navigator.pop(context, controller.text.trim());
                    }
                  : null,
              child: const Text('OK'),
            );
          },
        ),
      ],
    );
  }
}
