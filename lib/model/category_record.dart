import 'dart:convert';

class CategoryRecordType {
  String category;
  int amount;
  CategoryRecordType(
    this.category,
    this.amount,
  );

  CategoryRecordType copyWith({
    String? category,
    int? amount,
  }) {
    return CategoryRecordType(
      category ?? this.category,
      amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category,
      'amount': amount,
    };
  }

  factory CategoryRecordType.fromMap(Map<String, dynamic> map) {
    return CategoryRecordType(
      map['category'] as String,
      map['amount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryRecordType.fromJson(String source) =>
      CategoryRecordType.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CategoryRecordType(category: $category, amount: $amount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryRecordType &&
        other.category == category &&
        other.amount == amount;
  }

  @override
  int get hashCode => category.hashCode ^ amount.hashCode;
}
