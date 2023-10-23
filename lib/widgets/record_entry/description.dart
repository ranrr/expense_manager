import 'package:expense_manager/data/record_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Description extends StatelessWidget {
  const Description({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var recordProvider = context.watch<RecordProvider>();
    final desController = TextEditingController();
    desController.text = recordProvider.description;
    return TextFormField(
      initialValue: recordProvider.description,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      onChanged: (value) {
        recordProvider.setDescription(value);
      },
      decoration: InputDecoration(
        labelText: "Description",
        icon: const Icon(
          Icons.description,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: .75, color: Colors.grey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.blue),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: Colors.red),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
