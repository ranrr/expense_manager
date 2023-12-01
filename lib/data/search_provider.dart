import 'package:expense_manager/dataaccess/database.dart';
import 'package:expense_manager/model/transaction_record.dart';
import 'package:expense_manager/utils/constants.dart';
import 'package:flutter/material.dart';

class SearchProvider with ChangeNotifier {
  String _searchText = '';
  final List<bool> _typeSelected = <bool>[true, false, false];
  String _recordType = 'all';
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _showResults = false;

  String get searchText => _searchText;

  List<bool> get typeSelected => _typeSelected;

  String get recordType => _recordType;

  DateTime? get fromDate => _fromDate;

  DateTime? get toDate => _toDate;

  bool get showResults => _showResults;

  setSearchText(String text) {
    _searchText = text;
    setShowResults();
    notifyListeners();
  }

  setRecordType(int index) {
    for (int i = 0; i < _typeSelected.length; i++) {
      _typeSelected[i] = (i == index);
    }
    if (index == 1) {
      _recordType = RecordType.expense.name;
    } else if (index == 2) {
      _recordType = RecordType.income.name;
    } else {
      _recordType = 'all';
    }
    setShowResults();
    notifyListeners();
  }

  setSearchDates(DateTime from, DateTime to) {
    _fromDate = from;
    _toDate = to;
    setShowResults();
    notifyListeners();
  }

  setShowResults() {
    if (searchText.length < 3 && fromDate == null) {
      _showResults = false;
    } else {
      _showResults = true;
    }
  }

  Future<List<TxnRecord>> searchResults() async {
    if (fromDate != null) {
      return await DBProvider.db.searchRecords(
          searchText: searchText, type: recordType, from: fromDate, to: toDate);
    } else {
      return await DBProvider.db
          .searchRecords(searchText: searchText, type: recordType);
    }
  }
}
