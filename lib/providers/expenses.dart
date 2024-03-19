import 'package:expense_tracker/models/expese.dart';
import 'package:expense_tracker/services/expense_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpensesNotifier extends StateNotifier<List<Expense>> {
  ExpensesNotifier() : super([]);

  Future<void> getExpenses() async {
    final loadedExpenses = await ExpenseService().getExpenses();
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
  (ref) => ExpensesNotifier(),
);
