import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Description extends StatelessWidget {
  const Description({
    super.key,
    required this.description,
  });
  final String description;
  @override
  Widget build(BuildContext context) {
    var recordProvider = context.read<RecordProvider>();
    var desController = TextEditingController();
    desController.text = description;
    desController.selection =
        TextSelection.collapsed(offset: desController.text.length);

    return TextFormField(
      controller: desController,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      textCapitalization: TextCapitalization.sentences,
      onChanged: (value) {
        recordProvider.setDescription(value);
      },
      decoration: recordFormDecoration(
          text: "Description", iconData: Icons.description),
    );
  }
}
