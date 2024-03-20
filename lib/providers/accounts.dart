import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/services/account_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountNotifier extends StateNotifier<List<Account>> {
  AccountNotifier() : super([]);

  Future<void> getAccounts() async {
    final loadedAccounts = await AccountService().getAccounts();
    state = loadedAccounts;
  }

  void addAccount(Account account) {
    state = [...state, account];
  }

  void addAccountIndex(Account account, int index) {
    state.insert(index, account);
  }

  void removeAccount(Account account) {
    state = state.where((a) => a.id != account.id).toList();
  }

  void updateAccount(Account account) {
    state = state.map((a) => a.id == account.id ? account : a).toList();
  }

  int getIndex(Account account) {
    return state.indexOf(account);
  }
}

final accountsProvider = StateNotifierProvider<AccountNotifier, List<Account>>(
  (ref) => AccountNotifier(),
);
