import 'dart:convert';

class Category {
  int id;
  String category;
  String subCategory;
  String type;
  Category({
    required this.id,
    required this.category,
    required this.subCategory,
    required this.type,
  });

  Category copyWith({
    int? id,
    String? category,
    String? subCategory,
    String? type,
  }) {
    return Category(
      id: id ?? this.id,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category': category,
      'sub_category': subCategory,
      'type': type,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] as int,
      category: map['category'] as String,
      subCategory: map['sub_category'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Category(id: $id, category: $category, subCategory: $subCategory)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.category == category &&
        other.subCategory == subCategory;
  }

  @override
  int get hashCode => id.hashCode ^ category.hashCode ^ subCategory.hashCode;
}
