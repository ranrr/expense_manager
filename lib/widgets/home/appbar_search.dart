import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: () {},
        child: const Icon(
          Icons.search,
          size: 25,
        ),
      ),
    );
  }
}
