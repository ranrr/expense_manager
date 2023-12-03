class ChartData {
  final String x;
  final int y;
  ChartData({
    required this.x,
    required this.y,
  });

  factory ChartData.fromMap(Map<String, dynamic> map) {
    return ChartData(
      x: map['str'] as String,
      y: map['amount'] as int,
    );
  }

  @override
  String toString() => 'ChartData(x: $x, y: $y)';
}
