import 'package:expense_manager/widgets/record_entry/record_edit.dart';
import 'package:expense_manager/widgets/util/record_tile.dart';
import 'package:flutter/material.dart';
import 'package:expense_manager/model/record.dart';

class RecordsList extends StatelessWidget {
  const RecordsList({
    super.key,
    required this.records,
  });

  final List<Record> records;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditRecord(id: records[index].id!)),
              );
            },
            child: RecordTile(record: records[index]),
          );
        },
      ),
    );
  }
}
