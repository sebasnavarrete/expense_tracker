import 'package:expense_tracker/data/dummy_data.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/widgets/category_form.dart';
import 'package:expense_tracker/widgets/category_grid.dart';
import 'package:flutter/material.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  void _addCategory(Category category) {
    setState(() {
      dummyCategories.add(category);
    });
  }

  void _openCategoryForm(category) {
    showModalBottomSheet(
        elevation: 2,
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return CategoryForm(
              category: category, onCategorySubmit: _addCategory);
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = GridView(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      children: [
        for (final category in dummyCategories)
          CategoryGridItem(
            category: category,
            editCategory: () {
              _openCategoryForm(category);
            },
          ),
      ],
    );

    if (dummyCategories.isEmpty) {
      content = const Center(
        child: Text('No categories found, please add some.'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: content,
    );
  }
}
