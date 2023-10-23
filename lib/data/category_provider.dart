import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  Map<String, List<String>> categories = {
    "c1": ["a1", "a2"],
    "c2": ["b1", "b2"],
  };
}
