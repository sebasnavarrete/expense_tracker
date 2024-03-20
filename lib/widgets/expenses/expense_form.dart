import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/providers/accounts.dart';
import 'package:expense_tracker/providers/categories.dart';
import 'package:expense_tracker/services/expense_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expese.dart';
import 'package:expense_tracker/providers/expenses.dart';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

final dateFormater = DateFormat.yMMMd();

class ExpenseForm extends ConsumerStatefulWidget {
  const ExpenseForm({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  _ExpenseFormState createState() => _ExpenseFormState();
}

class _ExpenseFormState extends ConsumerState<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();

  var expenseId = '';
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  Category? _selectedCategory;
  Account? _selectedAccount;
  DateTime? _selectedDate = DateTime.now();

  _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year),
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  _submitData() async {
    final enteredAmount =
        double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (enteredAmount == null || enteredAmount <= 0) {
      return _showDialog();
    }

    Expense newExpense = Expense(
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
      account: _selectedAccount,
      notes: _notesController.text,
    );

    if (expenseId.isNotEmpty) {
      newExpense.id = expenseId;
      final response = await ExpenseService().updateExpense(
        newExpense,
      );
      ref.read(expensesProvider.notifier).updateExpense(newExpense);
    } else {
      final response = await ExpenseService().addExpense(
        newExpense,
      );
      newExpense.id = jsonDecode(response.body)['name'];
      ref.read(expensesProvider.notifier).addExpense(newExpense);
    }

    if (!context.mounted) {
      return;
    }

    Navigator.of(context).pop();
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

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.expense.amount > 0) {
      expenseId = widget.expense.id;
      _amountController.text = widget.expense.amount.toStringAsFixed(2);
      _selectedDate = widget.expense.date;
      _selectedCategory = widget.expense.category;
      _selectedAccount = widget.expense.account;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final accounts = ref.watch(accountsProvider);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    inputFormatters: [
                      CurrencyTextInputFormatter(
                        locale: 'es',
                        decimalDigits: 2,
                        symbol: '',
                      ),
                    ],
                    controller: _amountController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                        labelText: 'Amount', prefixText: '\€ '),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      return null;
                    },
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
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: _selectedCategory,
                    hint: const Text('Category'),
                    items: categories
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
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: _selectedAccount,
                    hint: const Text('Account'),
                    items: accounts
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
                Expanded(
                  child: TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                        labelText: 'Notes', hintText: 'Add notes'),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            if (Platform.isIOS)
              CupertinoButton.filled(
                onPressed: () {
                  _submitData();
                },
                child: const Text(
                  'Save Expense',
                ),
              )
            else
              ElevatedButton(
                onPressed: () {
                  _submitData();
                },
                child: const Text(
                  'Save Expense',
                ),
              )
          ],
        ),
      ),
    );
  }
}
