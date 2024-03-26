import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sentry/sentry.dart';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/category.dart';

// category service class
class CategoryService {
  User? user = FirebaseAuth.instance.currentUser;

  // get categories
  Future<dynamic> getCategories() async {
    try {
      final categoryData = await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('categories')
          .get();
      final List<Category> loadedCategories = [];
      for (final item in categoryData.docs) {
        final data = item.data();
        final subcategories = (data.containsKey('subcategories'))
            ? jsonDecode(data['subcategories'])
            : [];
        loadedCategories.add(
          Category(
            id: item.id,
            name: data['name'],
            icon: data['icon'],
            color: data['color'],
            subcategories: subcategories,
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
      final process = await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('categories')
          .add({
        'name': category.name,
        'icon': category.icon,
        'color': category.color,
        'subcategories': jsonEncode(category.subcategories),
      });
      return http.Response(process.id, 200);
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
      await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('categories')
          .doc(category.id)
          .update({
        'name': category.name,
        'icon': category.icon,
        'color': category.color,
        'subcategories': jsonEncode(category.subcategories),
      });

      return http.Response('Category updated', 200);
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
      await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('categories')
          .doc(category.id)
          .delete();

      return http.Response('Category removed', 200);
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to remove category', 500);
    }
  }
}
