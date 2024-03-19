import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";

final dateFormatter = DateFormat('dd-MM-yyyy');

class Expense {
  String id;
  final double amount;
  final DateTime date;
  final Category category;
  final Account account;
  String notes;

  Expense({
    this.id = '',
    required this.amount,
    required this.date,
    required this.category,
    required this.account,
    this.notes = '',
  });

  String get formattedDate => dateFormatter.format(date);
}

class ExpenseBucket {
  const ExpenseBucket({
    required this.category,
    required this.account,
    required this.expenses,
  });

  ExpenseBucket.forCategory(List<Expense> allExpenses, this.category)
      : expenses = allExpenses.where((e) => e.category == category).toList(),
        account = accountByType(AccountType.other);

  ExpenseBucket.forAccount(List<Expense> allExpenses, this.account)
      : expenses = allExpenses.where((e) => e.account == account).toList(),
        category = categoryByType(CategoryType.other);

  final Category? category;
  final Account? account;
  final List<Expense> expenses;

  double get totalExpenses {
    double total = 0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }
}

class ExpenseList {
  ExpenseList(this.expenses);

  final List<Expense> expenses;

// get grouped expenses by date using collection
  Map<String, List<Expense>> get groupedExpenses {
    final groupedExpenses = groupBy(expenses, (Expense e) => e.formattedDate);
    return groupedExpenses;
  }
}
