import 'package:expense_manager/widgets/search/date_type_filter.dart';
import 'package:expense_manager/widgets/search/search_input.dart';
import 'package:flutter/material.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 210,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SearchInput(),
          Padding(padding: EdgeInsets.all(15)),
          DateAndTypeFilter(),
        ],
      ),
    );
  }
}
