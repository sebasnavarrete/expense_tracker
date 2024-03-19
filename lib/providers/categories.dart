import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/services/category_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoriesNotifier extends StateNotifier<List<Category>> {
  CategoriesNotifier() : super([]);

  Future<void> getCategories() async {
    final loadedCategories = await CategoryService().getCategories();
    state = loadedCategories;
  }

  void addCategory(Category category) {
    state = [...state, category];
  }

  void addCategoryIndex(Category category, int index) {
    state.insert(index, category);
  }

  void removeCategory(Category category) {
    state = state.where((c) => c.id != category.id).toList();
  }

  void updateCategory(Category category) {
    state = state.map((c) => c.id == category.id ? category : c).toList();
  }

  int getIndex(Category category) {
    return state.indexOf(category);
  }
}

final categoriesProvider =
    StateNotifierProvider<CategoriesNotifier, List<Category>>(
  (ref) => CategoriesNotifier(),
);
