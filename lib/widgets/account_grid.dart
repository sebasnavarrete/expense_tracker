import 'package:expense_tracker/models/account.dart';
import 'package:flutter/material.dart';

class AccountGridItem extends StatelessWidget {
  const AccountGridItem({
    super.key,
    required this.account,
  });

  final Account account;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            account.color.withOpacity(0.6),
            account.color,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(account.name, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
