import 'dart:convert';

class CategoryGroupedBalance {
  final String category;
  final String subCategory;
  final int balance;
  CategoryGroupedBalance({
    required this.category,
    required this.subCategory,
    required this.balance,
  });

  CategoryGroupedBalance copyWith({
    String? category,
    String? subCategory,
    int? balance,
  }) {
    return CategoryGroupedBalance(
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category,
      'subCategory': subCategory,
      'balance': balance,
    };
  }

  factory CategoryGroupedBalance.fromMap(Map<String, dynamic> map) {
    return CategoryGroupedBalance(
      category: map['category'] as String,
      subCategory: map['sub_category'] as String,
      balance: map['amount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryGroupedBalance.fromJson(String source) =>
      CategoryGroupedBalance.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CategoryGroupedBalance(category: $category, subCategory: $subCategory, balance: $balance)';

  @override
  bool operator ==(covariant CategoryGroupedBalance other) {
    if (identical(this, other)) return true;

    return other.category == category &&
        other.subCategory == subCategory &&
        other.balance == balance;
  }

  @override
  int get hashCode =>
      category.hashCode ^ subCategory.hashCode ^ balance.hashCode;
}
