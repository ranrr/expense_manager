import 'package:expense_manager/widgets/home/home.dart';
import 'package:expense_manager/widgets/record_entry/record_add.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String homePage = '/';
  static const String addRecord = '/addRecord';
  RouteGenerator._();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
          builder: (_) => const MyHome(),
        );
      case addRecord:
        return MaterialPageRoute(
          builder: (_) => const AddRecord(),
        );
      default:
        throw const FormatException("Route not found");
    }
  }
}

class RouteException implements Exception {
  final String message;
  const RouteException(this.message);
}
