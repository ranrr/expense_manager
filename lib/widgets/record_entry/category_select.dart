import 'package:expense_manager/data/add_record_provider.dart';
import 'package:expense_manager/widgets/record_entry/category_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySelect extends StatelessWidget {
  const CategorySelect({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var recordProvider = context.watch<RecordProvider>();
    final catController = TextEditingController();
    catController.text = recordProvider.category;

    return TextFormField(
      controller: catController,
      readOnly: true,
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute<String>(
            builder: (BuildContext context) => const CategoryDisplay(),
          ),
        );
        if (result != null) {
          recordProvider.setCategory(result);
        }
      },
      decoration: InputDecoration(
        labelText: "Category",
        icon: const Icon(
          Icons.category,
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
