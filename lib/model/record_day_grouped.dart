// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:expense_manager/utils/constants.dart';

class RecordDateGrouped {
  final DateTime date;
  final RecordType type;
  final int balance;
  int expense = 0;
  int income = 0;

  RecordDateGrouped({
    required this.date,
    required this.type,
    required this.balance,
  });

  RecordDateGrouped copyWith({
    DateTime? date,
    RecordType? type,
    int? balance,
  }) {
    return RecordDateGrouped(
      date: date ?? this.date,
      type: type ?? this.type,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'type': type.name.toString(),
      'balance': balance,
    };
  }

  factory RecordDateGrouped.fromMap(Map<String, dynamic> map) {
    return RecordDateGrouped(
      date: DateTime.parse(map['date'].toString()),
      type: map['type'].toString() == RecordType.expense.name
          ? RecordType.expense
          : RecordType.income,
      balance: map['balance'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory RecordDateGrouped.fromJson(String source) =>
      RecordDateGrouped.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'RecordsDayGrouped(date: $date, type: $type, balance: $balance)';

  @override
  bool operator ==(covariant RecordDateGrouped other) {
    if (identical(this, other)) return true;

    return other.date == date && other.type == type && other.balance == balance;
  }

  @override
  int get hashCode => date.hashCode ^ type.hashCode ^ balance.hashCode;
}
