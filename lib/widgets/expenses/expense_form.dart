import 'dart:convert';
import 'dart:io';

import 'package:expense_tracker/helpers/helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/providers/accounts.dart';
import 'package:expense_tracker/providers/categories.dart';
import 'package:expense_tracker/services/expense_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';
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
    bool error = false;
    String errorMessage = '';
    final enteredAmount = double.tryParse(
            _amountController.text.replaceAll('.', '').replaceAll(',', '.')) ??
        0;
    //Replace to fix the issue with the thousands dot and decimal comma
    if (_selectedAccount == null) {
      error = true;
      errorMessage = 'Please select an account';
    }
    if (_selectedCategory == null) {
      error = true;
      errorMessage = 'Please select a category';
    }
    if (error || !_formKey.currentState!.validate()) {
      return _showDialog(errorMessage);
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
      await ExpenseService().updateExpense(
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Expense saved',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.of(context).pop();
  }

  void _showDialog(errorMessage) {
    final msg =
        errorMessage.isNotEmpty ? errorMessage : 'Please enter a valid amount';
    if (Platform.isIOS) {
      showCupertinoDialog(
          context: context,
          builder: (ctx) {
            return CupertinoAlertDialog(
              title: const Text('Invalid form'),
              content: Text(msg),
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
              title: const Text('Invalid form'),
              content: Text(msg),
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
                    autofocus: true,
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
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  decoration: BoxDecoration(
                                    color: Color(
                                        int.parse(category.color, radix: 16)),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Helper()
                                        .deserializeIconString(category.icon),
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  category.name.toUpperCase(),
                                ),
                              ],
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
                            child: Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  decoration: BoxDecoration(
                                    color: Color(
                                        int.parse(account.color, radix: 16)),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Helper()
                                        .deserializeIconString(account.icon),
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  account.name.toUpperCase(),
                                ),
                              ],
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
              height: 32,
            ),
            if (Platform.isIOS)
              CupertinoButton.filled(
                onPressed: () {
                  _submitData();
                },
                child: const Text(
                  'Save Expense',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            else
              ElevatedButton(
                onPressed: () {
                  _submitData();
                },
                child: const Text(
                  'Save Expense',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
