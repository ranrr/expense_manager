import 'package:expense_manager/widgets/search/search.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AppSearch(),
            ),
          );
        },
        child: const Icon(
          Icons.search,
          size: 25,
        ),
      ),
    );
  }
}
