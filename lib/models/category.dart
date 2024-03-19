import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';

class Category {
  Category({
    this.id = '',
    required this.name,
    required this.icon,
    required this.color,
  });

  String id;
  final String name;
  final String icon;
  final String color;
}

class CategoryList {
  CategoryList(this.categories);

  final List<Category> categories;

  Category categoryById(String id) {
    return categories.firstWhere((c) => c.id == id,
        orElse: () => Category(name: '', icon: '', color: ''));
  }
}

IconData? deserializeIconString(String icon) {
  if (icon.isEmpty) {
    return const IconData(0xe3af, fontFamily: 'MaterialIcons');
  }
  final iconData = jsonDecode(icon);
  return deserializeIcon(Map<String, dynamic>.from(iconData),
      iconPack: IconPack.allMaterial);
}
