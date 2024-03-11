import 'package:expense_tracker/models/account.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();
final dateFormatter = DateFormat('dd-MM-yyyy');

enum Category {
  food,
  transportation,
  housing,
  utilities,
  health,
  personal,
  entertainment,
  savings,
  investments,
  other,
}

const categoryIcons = {
  Category.food: Icons.fastfood,
  Category.transportation: Icons.directions_car,
  Category.housing: Icons.home,
  Category.utilities: Icons.flash_on,
  Category.health: Icons.healing,
  Category.personal: Icons.person,
  Category.entertainment: Icons.movie,
  Category.savings: Icons.account_balance,
  Category.investments: Icons.trending_up,
  Category.other: Icons.attach_money,
};

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
        category = Category.other;

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
