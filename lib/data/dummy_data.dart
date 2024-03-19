import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/models/expese.dart';
import 'package:flutter/material.dart';

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
