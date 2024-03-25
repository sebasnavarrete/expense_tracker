import 'package:expense_tracker/helpers/helper.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/material.dart';

class CategorySelectGrid extends StatelessWidget {
  final List<Category> categories;
  final Function(Category) onCategorySelected;

  const CategorySelectGrid({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          //width: double.infinity,
          child: // horizontal scroll with buttons
              ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            itemBuilder: (ctx, index) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Icon(
                    Helper().deserializeIconString(categories[0].icon),
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 200,
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
                    backgroundColor: Color(
                      int.parse(category.color, radix: 16),
                    ),
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
