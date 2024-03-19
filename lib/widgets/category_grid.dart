import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class CategoryGridItem extends StatelessWidget {
  const 1CategoryGridItem({
    super.key,
    required this.category,
    required this.onRemoveCategory,
    required this.editCategory,
  });

  final Category category;
  final void Function(Category) onRemoveCategory;
  final void Function(Category) editCategory;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(category.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 8),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (_) => onRemoveCategory(category),
      child: InkWell(
        onTap: () => editCategory(category),
        splashColor: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(int.parse(category.color, radix: 16)).withOpacity(0.7),
                Color(int.parse(category.color, radix: 16)),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Icon(
                deserializeIconString(category.icon),
                color: Colors.white,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
