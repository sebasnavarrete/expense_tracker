import 'package:expense_tracker/helpers/helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:flutter/material.dart';

class AccountSelectGrid extends StatelessWidget {
  final List<Account> accounts;
  final Function(Account) onAccountSelected;
  final Account? selectedAccount;

  const AccountSelectGrid({
    super.key,
    required this.accounts,
    required this.onAccountSelected,
    required this.selectedAccount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: GridView(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        children: [
          for (final account in accounts)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedAccount == account
                    ? Theme.of(context).colorScheme.secondary
                    : Color(
                        int.parse(account.color, radix: 16),
                      ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(4),
              ),
              onPressed: () {
                onAccountSelected(account);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Helper().deserializeIconString(account.icon),
                    color: Colors.white,
                    size: 20,
                  ),
                  FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      account.name,
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
