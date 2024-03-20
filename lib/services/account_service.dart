import 'dart:convert';

import 'package:expense_tracker/constants.dart';
import 'package:http/http.dart' as http;
import 'package:expense_tracker/models/account.dart';

class AccountService {
  static const backendUrl = Constants.backendUrl;

  // get accounts
  Future<List<Account>> getAccounts() async {
    try {
      final url = Uri.https(backendUrl, 'accounts.json');
      final response = await http.get(url);
      print(response.body);
      if (response.statusCode != 200) {
        throw Exception('Failed to load accounts');
      }
      if (response.body == 'null') {
        return [];
      }
      final Map<String, dynamic> accountsData = jsonDecode(response.body);
      final List<Account> loadedAccounts = [];
      for (final item in accountsData.entries) {
        loadedAccounts.add(
          Account(
            id: item.key,
            name: item.value['name'],
            icon: item.value['icon'],
            color: item.value['color'],
          ),
        );
      }
      return loadedAccounts;
    } catch (e) {
      print(e);
      return [];
    }
  }

  // add account
  Future<http.Response> addAccount(Account account) async {
    try {
      final url = Uri.https(backendUrl, 'accounts.json');
      final response = await http.post(
        url,
        body: jsonEncode({
          'name': account.name,
          'icon': account.icon,
          'color': account.color,
        }),
      );
      print('response.body ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to add account');
      }
      return response;
    } catch (e) {
      print(e);
      return http.Response('Failed to add account', 400);
    }
  }

  // update account
  Future<http.Response> updateAccount(Account account) async {
    try {
      final url = Uri.https(backendUrl, 'accounts/${account.id}.json');
      final response = await http.patch(
        url,
        body: jsonEncode({
          'name': account.name,
          'icon': account.icon,
          'color': account.color,
        }),
      );
      print('response.body ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to update account');
      }
      return response;
    } catch (e) {
      print(e);
      return http.Response('Failed to update account', 400);
    }
  }

  // remove account
  Future<http.Response> removeAccount(Account account) async {
    try {
      final url = Uri.https(backendUrl, 'accounts/${account.id}.json');
      final response = await http.delete(url);
      print('response.body ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to remove account');
      }
      return response;
    } catch (e) {
      print(e);
      return http.Response('Failed to remove account', 400);
    }
  }
}
