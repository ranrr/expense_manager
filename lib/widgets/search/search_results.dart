import 'package:expense_manager/data/search_provider.dart';
import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/widgets/util/record_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<SearchProvider>();
    if (!provider.showResults) {
      return const SizedBox();
    } else {
      return FutureBuilder<List<TxnRecord>>(
        future: provider.searchResults(),
        builder:
            (BuildContext context, AsyncSnapshot<List<TxnRecord>> snapshot) {
          Widget widget;
          if (snapshot.hasData) {
            List<TxnRecord> records = snapshot.data!;
            if (records.isEmpty) {
              widget = const Padding(
                padding: EdgeInsets.fromLTRB(28, 10, 0, 10),
                child: Text(
                  "No Transactions",
                  style: TextStyle(fontSize: 16),
                ),
              );
            } else {
              widget = Expanded(child: RecordsList(records: records));
            }
          } else if (snapshot.hasError) {
            widget = Container();
          } else {
            widget = Container();
          }
          return widget;
        },
      );
    }
  }
}
