class Account {
  Account({
    this.id = '',
    required this.name,
    required this.icon,
    required this.color,
  });

  String id;
  final String name;
  final String icon;
  final String color;
}

class AccountList {
  AccountList(this.accounts);

  final List<Account> accounts;

  Account accountById(String id) {
    return accounts.firstWhere((c) => c.id == id,
        orElse: () => Account(name: '', icon: '', color: ''));
  }
}
