import 'package:expense_tracker/data/dummy_data.dart';
import 'package:flutter/material.dart';

enum CategoryType {
  food,
  transportation,
  housing,
  utilities,
  health,
  personal,
  entertainment,
  savings,
  investments,
  other,
}

class Category {
  const Category({
    required this.id,
    required this.name,
    required this.categoryType,
    required this.icon,
    this.color = Colors.orange,
  });

  final String id;
  final String name;
  final int icon;
  final CategoryType categoryType;
  final Color color;
}

categoryByType(CategoryType categoryType) {
  const data = dummyCategories;
  return data.firstWhere((c) => c.categoryType == categoryType);
}
