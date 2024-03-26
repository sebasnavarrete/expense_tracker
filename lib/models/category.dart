class Category {
  Category({
    this.id = '',
    required this.name,
    required this.icon,
    required this.color,
    required this.subcategories,
  });

  String id;
  final String name;
  final String icon;
  final String color;
  final List subcategories;
}

class CategoryList {
  CategoryList(this.categories);

  final List<Category> categories;

  Category categoryById(String id) {
    return categories.firstWhere((c) => c.id == id,
        orElse: () => Category(
            name: 'No Category',
            icon: '{"pack":"cupertino","key":"xmark_octagon_fill"}',
            color: 'ffd50000',
            subcategories: []));
  }
}
