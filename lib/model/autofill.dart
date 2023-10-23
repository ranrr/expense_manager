// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AutoFill {
  String name;
  String account;
  String type;
  int amount;
  String category;
  String subCategory;
  String? description;
  AutoFill({
    required this.name,
    required this.account,
    required this.type,
    required this.amount,
    required this.category,
    required this.subCategory,
    this.description,
  });

  AutoFill copyWith({
    String? name,
    String? account,
    String? type,
    int? amount,
    String? category,
    String? subCategory,
    String? description,
  }) {
    return AutoFill(
      name: name ?? this.name,
      account: account ?? this.account,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'account': account,
      'type': type,
      'amount': amount,
      'category': category,
      'sub_category': subCategory,
      'description': description,
    };
  }

  factory AutoFill.fromMap(Map<String, dynamic> map) {
    return AutoFill(
      name: map['name'] as String,
      account: map['account'] as String,
      type: map['type'] as String,
      amount: map['amount'] as int,
      category: map['category'] as String,
      subCategory: map['sub_category'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AutoFill.fromJson(String source) =>
      AutoFill.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AutoFill(name: $name, account: $account, type: $type, amount: $amount, category: $category, subCategory: $subCategory, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AutoFill &&
        other.name == name &&
        other.account == account &&
        other.type == type &&
        other.amount == amount &&
        other.category == category &&
        other.subCategory == subCategory &&
        other.description == description;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        account.hashCode ^
        type.hashCode ^
        amount.hashCode ^
        category.hashCode ^
        subCategory.hashCode ^
        description.hashCode;
  }
}
