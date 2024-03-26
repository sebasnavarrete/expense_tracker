import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/providers/categories.dart';
import 'package:expense_tracker/services/category_service.dart';
import 'package:expense_tracker/widgets/categories/category_form.dart';
import 'package:expense_tracker/widgets/categories/category_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesScreen extends ConsumerStatefulWidget {
  const CategoriesScreen({super.key});

  @override
  ConsumerState<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends ConsumerState<CategoriesScreen> {
  late Future<void> _categoriesFuture;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = ref.read(categoriesProvider.notifier).getCategories();
  }

  void _removeCategory(Category category) {
    final categoryIndex =
        ref.read(categoriesProvider.notifier).getIndex(category);
    ref.read(categoriesProvider.notifier).removeCategory(category);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: const Text('Category removed'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  ref
                      .read(categoriesProvider.notifier)
                      .addCategoryIndex(category, categoryIndex);
                });
              },
            ),
          ),
        )
        .closed
        .then((reason) async {
      if (reason != SnackBarClosedReason.action) {
        final response = await CategoryService().removeCategory(category);
        if (response.statusCode >= 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to remove category'),
            ),
          );
          ref.read(categoriesProvider.notifier).addCategoryIndex(
                category,
                categoryIndex,
              );
        }
      }
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
            category: category,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Category> registeredCategories = ref.watch(categoriesProvider);

    Widget content = FutureBuilder(
      future: _categoriesFuture,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : GridView(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4 / 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  children: [
                    for (final category in registeredCategories)
                      CategoryGridItem(
                        category: category,
                        editCategory: _openCategoryForm,
                        onRemoveCategory: _removeCategory,
                      ),
                  ],
                ),
    );

    if (registeredCategories.isEmpty) {
      content = const Center(
        child: Text('No categories found, please add some.'),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
        ),
        body: content,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openCategoryForm(null),
          child: const Icon(Icons.add),
        ));
  }
}
