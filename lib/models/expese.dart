import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final dateFormatter = DateFormat('dd-MM-yyyy');

class Expense {
  final String id;
  final double amount;
  final DateTime date;
  final Category category;
  final Account account;

  Expense({
    required this.amount,
    required this.date,
    required this.category,
    required this.account,
  }) : id = uuid.v4();

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
