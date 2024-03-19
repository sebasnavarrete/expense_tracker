import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/models/expese.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';

class ExpenseService {
  static const backendUrl = Constants.backendUrl;

  Future<dynamic> getExpenses() async {
    try {
      final url = Uri.https(backendUrl, 'expenses.json');
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Failed to load expenses');
      }
      print(response.body);
      if (response.body == 'null') {
        return [];
      }
      final Map<String, dynamic> expensesData = jsonDecode(response.body);
      return expensesData;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<http.Response> addExpense(Expense expense) async {
    final url = Uri.https(backendUrl, 'expenses.json');
    final response = await http.post(
      url,
      body: jsonEncode({
        'amount': expense.amount,
        'date': expense.date.toIso8601String(),
        'category': expense.category!.id,
        'account': expense.account!.id,
        'notes': expense.notes,
      }),
    );
    return response;
  }

  Future<http.Response> updateExpense(Expense expense) async {
    final url = Uri.https(backendUrl, 'expenses/${expense.id}.json');
    final response = await http.patch(
      url,
      body: jsonEncode({
        'amount': expense.amount,
        'date': expense.date.toIso8601String(),
        'category': expense.category!.id,
        'account': expense.account!.id,
        'notes': expense.notes,
      }),
    );
    return response;
  }

  Future<http.Response> removeExpense(Expense expense) async {
    final url = Uri.https(backendUrl, 'expenses/${expense.id}.json');
    final response = await http.delete(url);
    return response;
  }
}
