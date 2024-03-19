import 'package:expense_tracker/data/dummy_data.dart';
import 'package:expense_tracker/widgets/account_grid.dart';
import 'package:flutter/material.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Widget content = GridView(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      children: [
        for (final account in dummyAccounts) AccountGridItem(account: account),
      ],
    );

    if (dummyAccounts.isEmpty) {
      content = const Center(
        child: Text('No accounts found, please add some.'),
      );
    }

    return Scaffold(
      body: content,
    );
  }
}
