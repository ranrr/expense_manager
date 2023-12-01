import 'package:expense_manager/data/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SearchProvider>();
    var controller = TextEditingController();
    controller.text = provider.searchText;
    controller.selection =
        TextSelection.collapsed(offset: controller.text.length);
    return TextFormField(
      autofocus: true,
      controller: controller,
      onChanged: (String value) {
        provider.setSearchText(value);
      },
      decoration: const InputDecoration(icon: Icon(Icons.search)),
    );
  }
}
