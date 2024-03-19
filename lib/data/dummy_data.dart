import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expese.dart';
import 'package:flutter/material.dart';

List<Expense> dummyExpenses = [
  Expense(
    id: '1',
    amount: 19.99,
    date: DateTime.now(),
    category: categoryByType(CategoryType.food),
    account: accountByType(AccountType.cash),
  ),
  Expense(
    id: '2',
    amount: 15.00,
    date: DateTime.now(),
    category: categoryByType(CategoryType.transportation),
    account: accountByType(AccountType.creditCard),
  ),
  Expense(
    id: '3',
    amount: 100.00,
    date: DateTime.now(),
    category: categoryByType(CategoryType.food),
    account: accountByType(AccountType.bankAccount),
  ),
  Expense(
    id: '4',
    amount: 20.00,
    date: DateTime.now(),
    category: categoryByType(CategoryType.personal),
    account: accountByType(AccountType.creditCard),
  ),
];

const List<Account> dummyAccounts = [
  Account(
    id: '1',
    name: 'Cash',
    accountType: AccountType.cash,
    color: Colors.orange,
  ),
  Account(
    id: '2',
    name: 'Credit Card',
    accountType: AccountType.creditCard,
    color: Colors.blue,
  ),
  Account(
    id: '3',
    name: 'Bank Account',
    accountType: AccountType.bankAccount,
    color: Colors.green,
  ),
  Account(
    id: '4',
    name: 'Other',
    accountType: AccountType.other,
    color: Colors.purple,
  ),
];

const List<Category> dummyCategories = [
  Category(
    id: '1',
    name: 'Food',
    categoryType: CategoryType.food,
    icon: 0xe25a,
    color: Colors.orange,
  ),
  Category(
    id: '2',
    name: 'Transportation',
    categoryType: CategoryType.transportation,
    icon: 0xe1d7,
    color: Colors.blue,
  ),
  Category(
    id: '3',
    name: 'Housing',
    categoryType: CategoryType.housing,
    icon: 0xe318,
    color: Colors.green,
  ),
  Category(
    id: '4',
    name: 'Utilities',
    categoryType: CategoryType.utilities,
    icon: 0xe293,
    color: Colors.purple,
  ),
  Category(
    id: '5',
    name: 'Health',
    categoryType: CategoryType.health,
    icon: 0xe5d0,
    color: Colors.orange,
  ),
  Category(
    id: '6',
    name: 'Personal',
    categoryType: CategoryType.personal,
    icon: 0xe491,
    color: Colors.blue,
  ),
  Category(
    id: '7',
    name: 'Entertainment',
    categoryType: CategoryType.entertainment,
    icon: 0xe8e0,
    color: Colors.green,
  ),
  Category(
    id: '8',
    name: 'Savings',
    categoryType: CategoryType.savings,
    icon: 0xe1b3,
    color: Colors.purple,
  ),
  Category(
    id: '9',
    name: 'Investments',
    categoryType: CategoryType.investments,
    icon: 0xe227,
    color: Colors.orange,
  ),
  Category(
    id: '10',
    name: 'Other',
    categoryType: CategoryType.other,
    icon: 0xe2c8,
    color: Colors.blue,
  ),
];
