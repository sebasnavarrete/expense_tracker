import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/expese.dart';
import 'package:flutter/material.dart';

List<Expense> dummyExpenses = [
  Expense(
    amount: 19.99,
    date: DateTime.now(),
    category: Category.food,
    account: accountByType(AccountType.cash),
  ),
  Expense(
    amount: 15.00,
    date: DateTime.now(),
    category: Category.transportation,
    account: accountByType(AccountType.creditCard),
  ),
  Expense(
    amount: 100.00,
    date: DateTime.now(),
    category: Category.food,
    account: accountByType(AccountType.bankAccount),
  ),
  Expense(
    amount: 20.00,
    date: DateTime.now(),
    category: Category.personal,
    account: accountByType(AccountType.creditCard),
  ),
  Expense(
    amount: 10.00,
    date: DateTime.now(),
    category: Category.transportation,
    account: accountByType(AccountType.bankAccount),
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
