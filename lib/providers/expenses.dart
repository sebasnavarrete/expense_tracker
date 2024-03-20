import 'package:expense_tracker/models/expese.dart';
import 'package:expense_tracker/providers/accounts.dart';
import 'package:expense_tracker/services/expense_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';

import 'package:expense_tracker/providers/categories.dart';

class ExpensesNotifier extends StateNotifier<List<Expense>> {
  ExpensesNotifier(this.ref) : super([]);

  final ref;

  Future<void> getExpenses() async {
    bool error = false;
    final getData = await ExpenseService().getExpenses().catchError((e) {
      error = true;
      return print('error: $e');
    });
    if (error) return;
    var categories = ref.read(categoriesProvider);
    var accounts = ref.read(accountsProvider);
    if (categories.isEmpty) {
      await ref.read(categoriesProvider.notifier).getCategories();
      categories = ref.read(categoriesProvider);
    }
    if (accounts.isEmpty) {
      await ref.read(accountsProvider.notifier).getAccounts();
      accounts = ref.read(accountsProvider);
    }
    final List<Expense> loadedExpenses = [];
    if (getData.entries.isNotEmpty) {
      for (final item in getData.entries) {
        loadedExpenses.add(
          Expense(
            id: item.key,
            amount: item.value['amount'],
            date: DateTime.parse(item.value['date']),
            category:
                CategoryList(categories).categoryById(item.value['category']),
            account: AccountList(accounts).accountById(item.value['account']),
            notes: item.value['notes'] ?? '',
          ),
        );
      }
    }
    state = loadedExpenses;
  }

  void addExpense(Expense expense) {
    state = [...state, expense];
  }

  void addExpenseIndex(Expense expense, int index) {
    state.insert(index, expense);
  }

  void removeExpense(Expense expense) {
    state = state.where((e) => e.id != expense.id).toList();
  }

  void updateExpense(Expense expense) {
    state = state.map((e) => e.id == expense.id ? expense : e).toList();
  }

  int getIndex(Expense expense) {
    return state.indexOf(expense);
  }
}

final expensesProvider = StateNotifierProvider<ExpensesNotifier, List<Expense>>(
  (ref) => ExpensesNotifier(ref),
);
