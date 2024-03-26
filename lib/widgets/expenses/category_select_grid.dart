import 'package:expense_tracker/helpers/helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class CategorySelectGrid extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onCategorySelected;
  final Function(String) onSubCategorySelected;
  List subcategories;
  final Category? selectedCategory;
  final String selectedSubCategory;

  CategorySelectGrid({
    super.key,
    required this.categories,
    required this.subcategories,
    required this.onCategorySelected,
    required this.onSubCategorySelected,
    required this.selectedCategory,
    required this.selectedSubCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (subcategories.length > 0)
          SizedBox(
            height: 40,
            width: double.infinity,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              scrollDirection: Axis.horizontal,
              itemCount: subcategories.length,
              itemBuilder: (ctx, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          selectedSubCategory == subcategories[index]
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.grey[500],
                      elevation:
                          (selectedSubCategory == subcategories[index]) ? 8 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: () {
                      onSubCategorySelected(subcategories[index]);
                    },
                    child: Text(
                      subcategories[index],
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 8),
        SizedBox(
          height: 250,
          width: double.infinity,
          child: GridView(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            children: [
              for (final category in categories)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedCategory == category
                        ? Theme.of(context).colorScheme.secondary
                        : Color(
                            int.parse(category.color, radix: 16),
                          ),
                    elevation: (selectedCategory != null &&
                            selectedCategory!.id == category.id)
                        ? 8
                        : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                  ),
                  onPressed: () {
                    onCategorySelected(category);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Helper().deserializeIconString(category.icon),
                        color: Colors.white,
                        size: 20,
                      ),
                      FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          category.name,
                          style:
                              Theme.of(context).textTheme.labelMedium!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
