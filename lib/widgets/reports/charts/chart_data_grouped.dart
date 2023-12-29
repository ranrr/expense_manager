import 'dart:convert';

class GroupedChartData {
  final String str;
  final String category;
  final DateTime date;
  final int amt;
  GroupedChartData({
    required this.str,
    required this.category,
    required this.date,
    required this.amt,
  });

  factory GroupedChartData.fromMap(Map<String, dynamic> map) {
    return GroupedChartData(
      str: map['str'] as String,
      category: map['category'] as String,
      date: DateTime.parse(map['date']),
      amt: map['amount'] as int,
    );
  }

  GroupedChartData copyWith({
    String? str,
    String? category,
    DateTime? date,
    int? amt,
  }) {
    return GroupedChartData(
      str: str ?? this.str,
      category: category ?? this.category,
      date: date ?? this.date,
      amt: amt ?? this.amt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'str': str,
      'category': category,
      'date': date.millisecondsSinceEpoch,
      'amt': amt,
    };
  }

  String toJson() => json.encode(toMap());

  factory GroupedChartData.fromJson(String source) =>
      GroupedChartData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LineChartData(str: $str, category: $category, date: $date, amt: $amt)';
  }

  @override
  bool operator ==(covariant GroupedChartData other) {
    if (identical(this, other)) return true;

    return other.str == str &&
        other.category == category &&
        other.date == date &&
        other.amt == amt;
  }

  @override
  int get hashCode {
    return str.hashCode ^ category.hashCode ^ date.hashCode ^ amt.hashCode;
  }
}
