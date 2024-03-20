import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/providers/accounts.dart';
import 'package:expense_tracker/services/account_service.dart';
import 'package:expense_tracker/widgets/accounts/account_form.dart';
import 'package:expense_tracker/widgets/accounts/account_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsScreen extends ConsumerStatefulWidget {
  const AccountsScreen({super.key});

  @override
  ConsumerState<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends ConsumerState<AccountsScreen> {
  late Future<void> _accountsFuture;

  @override
  void initState() {
    super.initState();
    _accountsFuture = ref.read(accountsProvider.notifier).getAccounts();
  }

  void _removeAccount(Account account) {
    final accountIndex = ref.read(accountsProvider.notifier).getIndex(account);
    ref.read(accountsProvider.notifier).removeAccount(account);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: const Text('Account removed'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  ref
                      .read(accountsProvider.notifier)
                      .addAccountIndex(account, accountIndex);
                });
              },
            ),
          ),
        )
        .closed
        .then((reason) async {
      if (reason != SnackBarClosedReason.action) {
        final response = await AccountService().removeAccount(account);
        if (response.statusCode >= 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to remove account'),
            ),
          );
          ref.read(accountsProvider.notifier).addAccountIndex(
                account,
                accountIndex,
              );
        }
      }
    });
  }

  void _openAccountForm(account) {
    showModalBottomSheet(
        elevation: 2,
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return AccountForm(
            account: account,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Account> registeredAccounts = ref.watch(accountsProvider);

    Widget content = FutureBuilder(
      future: _accountsFuture,
      builder: (context, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? const Center(child: CircularProgressIndicator())
              : GridView(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  children: [
                    for (final account in registeredAccounts)
                      AccountGridItem(
                        account: account,
                        editAccount: _openAccountForm,
                        onRemoveAccount: _removeAccount,
                      ),
                  ],
                ),
    );

    if (registeredAccounts.isEmpty) {
      content = const Center(
        child: Text('No accounts found, please add some.'),
      );
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Accounts'),
        ),
        body: content,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openAccountForm(null),
          child: const Icon(Icons.add),
        ));
  }
}
