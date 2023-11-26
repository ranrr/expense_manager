import 'package:expense_manager/data/record_provider.dart';
import 'package:expense_manager/utils/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Description extends StatelessWidget {
  const Description({super.key});
  @override
  Widget build(BuildContext context) {
    var recordProvider = context.read<RecordProvider>();
    print('**********************description build');
    return TextFormField(
      initialValue: recordProvider.description,
      keyboardType: TextInputType.multiline,
      maxLines: 3,
      onChanged: (value) {
        recordProvider.setDescription(value);
      },
      decoration: recordFormDecoration(
          text: "Description", iconData: Icons.description),
    );
  }
}
