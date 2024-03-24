import 'package:expense_tracker/helpers/helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:flutter/material.dart';

class AccountGridItem extends StatelessWidget {
  const AccountGridItem({
    super.key,
    required this.account,
    required this.onRemoveAccount,
    required this.editAccount,
  });

  final Account account;
  final void Function(Account) onRemoveAccount;
  final void Function(Account) editAccount;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      key: ValueKey(account.id),
      background: Container(
        color: Theme.of(context).colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 8),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (_) => onRemoveAccount(account),
      child: InkWell(
        onTap: () => editAccount(account),
        splashColor: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(int.parse(account.color, radix: 16)).withOpacity(0.7),
                Color(int.parse(account.color, radix: 16)),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                account.name,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Icon(
                Helper().deserializeIconString(account.icon),
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
