import 'dart:convert';
import 'package:sentry/sentry.dart';
import 'package:expense_tracker/constants.dart';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/category.dart';

// category service class
class CategoryService {
  static const backendUrl = Constants.backendUrl;

  // get categories
  Future<dynamic> getCategories() async {
    try {
      final url = Uri.https(backendUrl, 'categories.json');
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to load categories');
      }
      if (response.body == 'null') {
        return [];
      }
      final Map<String, dynamic> categoriesData = jsonDecode(response.body);
      final List<Category> loadedCategories = [];
      for (final item in categoriesData.entries) {
        loadedCategories.add(
          Category(
            id: item.key,
            name: item.value['name'],
            icon: item.value['icon'],
            color: item.value['color'],
          ),
        );
      }
      return loadedCategories;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to get categories', 500);
    }
  }

  // add category
  Future<http.Response> addCategory(Category category) async {
    try {
      final url = Uri.https(backendUrl, 'categories.json');
      final response = await http.post(
        url,
        body: jsonEncode({
          'name': category.name,
          'icon': category.icon,
          'color': category.color,
        }),
      );
      //print('response.body ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to add category');
      }
      return response;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to add category', 500);
    }
  }

  // update category
  Future<http.Response> updateCategory(Category category) async {
    try {
      final url = Uri.https(backendUrl, 'categories/${category.id}.json');
      final response = await http.patch(
        url,
        body: jsonEncode({
          'name': category.name,
          'icon': category.icon,
          'color': category.color,
        }),
      );
      //print('response.body ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Failed to update category');
      }
      return response;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to remove category', 500);
    }
  }

  // remove category
  Future<http.Response> removeCategory(Category category) async {
    try {
      final url = Uri.https(backendUrl, 'categories/${category.id}.json');
      final response = await http.delete(url);
      //print('response.body ${response.body}');
      if (response.statusCode != 200) {
        throw Exception('Failed to remove category');
      }
      return response;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to remove category', 500);
    }
  }
}
