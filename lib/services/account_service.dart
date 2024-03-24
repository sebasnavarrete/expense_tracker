import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sentry/sentry.dart';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/account.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountService {
  User? user = FirebaseAuth.instance.currentUser;

  // get accounts
  Future<dynamic> getAccounts() async {
    try {
      final accountsData = await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('accounts')
          .get();
      final List<Account> loadedAccounts = [];
      for (final item in accountsData.docs) {
        final data = item.data();
        loadedAccounts.add(
          Account(
            id: item.id,
            name: data['name'],
            icon: data['icon'],
            color: data['color'],
          ),
        );
      }
      return loadedAccounts;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to get accounts', 500);
    }
  }

  // add account
  Future<http.Response> addAccount(Account account) async {
    try {
      final process = await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('accounts')
          .add({
        'name': account.name,
        'icon': account.icon,
        'color': account.color,
      });
      return http.Response(process.id, 200);
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to add account', 500);
    }
  }

  // update account
  Future<http.Response> updateAccount(Account account) async {
    try {
      await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('accounts')
          .doc(account.id)
          .update({
        'name': account.name,
        'icon': account.icon,
        'color': account.color,
      });

      return http.Response('Account updated', 200);
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to update account', 500);
    }
  }

  // remove account
  Future<http.Response> removeAccount(Account account) async {
    try {
      await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('accounts')
          .doc(account.id)
          .delete();

      return http.Response('Account removed', 200);
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to remove account', 500);
    }
  }
}
