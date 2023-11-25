import 'dart:convert';

class TxnRecord {
  int? id;
  final String account;
  final String type;
  final int amount;
  final String category;
  final String subCategory;
  final DateTime date;
  final String description;
  TxnRecord({
    this.id,
    required this.account,
    required this.type,
    required this.amount,
    required this.category,
    required this.subCategory,
    required this.date,
    required this.description,
  });

  TxnRecord copyWith({
    String? account,
    String? type,
    int? amount,
    String? category,
    String? subCategory,
    DateTime? date,
    String? description,
  }) {
    return TxnRecord(
      account: account ?? this.account,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      date: date ?? this.date,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'account': account,
      'type': type,
      'amount': amount,
      'category': category,
      'subCategory': subCategory,
      'date': date.millisecondsSinceEpoch,
      'description': description,
    };
  }

  factory TxnRecord.fromMap(Map<String, dynamic> map) {
    return TxnRecord(
      id: map['id'] as int,
      account: map['account'] as String,
      type: map['type'] as String,
      amount: map['amount'] as int,
      category: map['category'] as String,
      subCategory: map['sub_category'] as String,
      date: DateTime.parse(map['date']),
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TxnRecord.fromJson(String source) =>
      TxnRecord.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Record(account: $account, type: $type, amount: $amount, category: $category, subCategory: $subCategory, date: $date, description: $description)';
  }

  @override
  bool operator ==(covariant TxnRecord other) {
    if (identical(this, other)) return true;

    return other.account == account &&
        other.type == type &&
        other.amount == amount &&
        other.category == category &&
        other.subCategory == subCategory &&
        other.date == date &&
        other.description == description;
  }

  @override
  int get hashCode {
    return account.hashCode ^
        type.hashCode ^
        amount.hashCode ^
        category.hashCode ^
        subCategory.hashCode ^
        date.hashCode ^
        description.hashCode;
  }
}
