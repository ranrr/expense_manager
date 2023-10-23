// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:expense_manager/model/record.dart';

class RecordData with ChangeNotifier {
  Record? record;
  RecordAction? action;
  RecordData({
    this.record,
    this.action,
  });
}
