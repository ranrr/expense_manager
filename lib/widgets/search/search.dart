import 'package:expense_manager/data/search_provider.dart';
import 'package:expense_manager/widgets/search/search_filter.dart';
import 'package:expense_manager/widgets/search/search_results.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppSearch extends StatelessWidget {
  const AppSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: ChangeNotifierProvider<SearchProvider>(
        create: (context) => SearchProvider(),
        child: const Column(
          children: [
            SearchFilter(),
            SearchResults(),
          ],
        ),
      ),
    );
  }
}
