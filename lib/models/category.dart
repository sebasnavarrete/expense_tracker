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
