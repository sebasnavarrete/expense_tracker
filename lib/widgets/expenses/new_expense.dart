import 'package:expense_tracker/data/dummy_data.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expese.dart';
import 'dart:io';

final dateFormater = DateFormat.yMMMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense newExpense) onAddExpense;

  @override
  _NewExpenseState createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _amountController = TextEditingController();
  Category _selectedCategory = categoryByType(CategoryType.food);
  Account _selectedAccount = accountByType(AccountType.creditCard);
  DateTime? _selectedDate = DateTime.now();

  _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year),
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) {
            return CupertinoAlertDialog(
              title: const Text('Invalid amount'),
              content: const Text('Please enter a valid amount'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: const Text('Invalid amount'),
              content: const Text('Please enter a valid amount'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: const Text('Okay'),
                ),
              ],
            );
          });
    }
  }

  _submitData() {
    final enteredAmount = double.tryParse(_amountController.text);
    if (enteredAmount == null || enteredAmount <= 0) {
      return _showDialog();
    }

    final newExpense = Expense(
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
      account: _selectedAccount,
    );

    widget.onAddExpense(newExpense);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                      labelText: 'Amount', prefixText: '\$ '),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.centerLeft,
                  ),
                  onPressed: _presentDatePicker,
                  child: Text(
                    textAlign: TextAlign.left,
                    _selectedDate == null
                        ? 'Select date'
                        : 'Date: ${dateFormater.format(_selectedDate!)}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                  onPressed: _presentDatePicker,
                  icon: const Icon(Icons.calendar_today),
                  alignment: Alignment.centerRight,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Category',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedCategory,
                  hint: const Text('Category'),
                  items: dummyCategories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(
                            category.name.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Account',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: _selectedAccount,
                  hint: const Text('Account'),
                  items: dummyAccounts
                      .map(
                        (account) => DropdownMenuItem(
                          value: account,
                          child: Text(
                            account.name.toUpperCase(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedAccount = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              if (Platform.isIOS)
                CupertinoButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                  ),
                )
              else
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                  ),
                ),
              const Spacer(),
              if (Platform.isIOS)
                CupertinoButton.filled(
                  onPressed: () {
                    _submitData();
                  },
                  child: const Text(
                    'Add Expense',
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    _submitData();
                  },
                  child: const Text(
                    'Add Expense',
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
