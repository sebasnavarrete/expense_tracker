import 'package:expense_tracker/data/dummy_data.dart';
import 'package:flutter/material.dart';

enum AccountType {
  cash,
  creditCard,
  bankAccount,
  other,
}

class Account {
  const Account({
    required this.id,
    required this.name,
    required this.accountType,
    this.color = Colors.orange,
  });

  final String id;
  final String name;
  final AccountType accountType;
  final Color color;
}

accountByType(AccountType accountType) {
  const accounts = dummyAccounts;
  return accounts.firstWhere((account) => account.accountType == accountType);
}

accountById(String accountId) {
  const accounts = dummyAccounts;
  return accounts.firstWhere((account) => account.id == accountId);
}
