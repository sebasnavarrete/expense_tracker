import 'dart:io';

import 'package:expense_tracker/helpers/helper.dart';
import 'package:expense_tracker/models/account.dart';
import 'package:expense_tracker/models/category.dart';
import 'package:expense_tracker/providers/accounts.dart';
import 'package:expense_tracker/providers/categories.dart';
import 'package:expense_tracker/services/expense_service.dart';
import 'package:expense_tracker/widgets/expenses/account_select_grid.dart';
import 'package:expense_tracker/widgets/expenses/category_select_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/providers/expenses.dart';

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
  String _selectedSubCategory = '';
  Account? _selectedAccount;
  DateTime? _selectedDate = DateTime.now();
  var saving = false;
  var _selectedOption = 'amount';

  _presentDatePicker() async {
    final now = DateTime.now();
    setState(() {
      _selectedOption = 'date';
    });
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year),
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
      _selectedOption = '';
    });
  }

  _delayAction(action) {
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      action();
    });
  }

  _nextStep() {
    Future.delayed(Duration(milliseconds: 300)).then((value) {
      if (_selectedOption == 'amount') {
        setState(() {
          _selectedOption = 'category';
        });
      } else if (_selectedOption == 'notes') {
        _presentDatePicker();
      }
    });
  }

  _submitData() async {
    setState(() {
      saving = true;
    });
    bool error = false;
    String errorMessage = '';
    final enteredAmount = double.tryParse(_amountController.text) ?? 0;
    if (_selectedAccount == null) {
      error = true;
      errorMessage = 'Please select an account';
    }
    if (_selectedCategory == null) {
      error = true;
      errorMessage = 'Please select a category';
    }
    if (error || !_formKey.currentState!.validate()) {
      setState(() {
        saving = false;
      });
      return _showDialog(errorMessage);
    }
    Expense newExpense = Expense(
      amount: enteredAmount,
      date: _selectedDate!,
      category: _selectedCategory,
      account: _selectedAccount,
      notes: _notesController.text,
      subcategory: _selectedSubCategory,
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
      newExpense.id = response.body;
      ref.read(expensesProvider.notifier).addExpense(newExpense);
    }
    setState(() {
      saving = false;
    });
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
      _notesController.text = widget.expense.notes;
      _selectedSubCategory = widget.expense.subcategory;
    }
  }

  @override
  Widget build(BuildContext context) {
    UnfocusDisposition disposition = UnfocusDisposition.scope;
    final categories = ref.watch(categoriesProvider);
    final accounts = ref.watch(accountsProvider);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedOption == 'amount'
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Colors.transparent,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          _selectedOption = 'amount';
                        });
                      },
                      autofocus: true,
                      controller: _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                          labelText: 'Amount', prefixText: '\€ '),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            double.tryParse(value) == null) {
                          return 'Please enter a valid amount';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Category
            InkWell(
              splashColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              onTap: () {
                setState(() {
                  if (_selectedOption == 'amount' ||
                      _selectedOption == 'notes') {
                    primaryFocus!.unfocus(disposition: disposition);
                    _delayAction(() {
                      setState(() {
                        _selectedOption = 'category';
                      });
                    });
                  } else {
                    setState(() {
                      _selectedOption = 'category';
                    });
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedOption == 'category'
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    if (_selectedCategory != null)
                      Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Color(
                              int.parse(_selectedCategory!.color, radix: 16)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Helper()
                              .deserializeIconString(_selectedCategory!.icon),
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    Text(
                      _selectedCategory == null
                          ? 'Category not selected'
                          : _selectedCategory!.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_selectedSubCategory != '') const SizedBox(width: 8),
                    Text(
                      _selectedSubCategory.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Account
            InkWell(
              splashColor:
                  Theme.of(context).colorScheme.primary.withOpacity(0.2),
              onTap: () {
                if (_selectedOption == 'amount' || _selectedOption == 'notes') {
                  primaryFocus!.unfocus(disposition: disposition);
                  _delayAction(() {
                    setState(() {
                      _selectedOption = 'account';
                    });
                  });
                } else {
                  setState(() {
                    _selectedOption = 'account';
                  });
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: _selectedOption == 'account'
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
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
                    const Spacer(),
                    if (_selectedAccount != null)
                      Container(
                        padding: const EdgeInsets.all(4),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Color(
                              int.parse(_selectedAccount!.color, radix: 16)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Helper()
                              .deserializeIconString(_selectedAccount!.icon),
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    Text(
                      _selectedAccount == null
                          ? 'Account not selected'
                          : _selectedAccount!.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: _selectedOption == 'notes'
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Colors.transparent,
              ),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: TextFormField(
                onTap: () {
                  setState(() {
                    _selectedOption = 'notes';
                  });
                },
                controller: _notesController,
                decoration: const InputDecoration(
                    labelText: 'Notes', hintText: 'Add notes'),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedOption == 'date'
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () {
                        setState(() {
                          primaryFocus!.unfocus(disposition: disposition);
                        });
                        _presentDatePicker();
                      },
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
                      onPressed: () {
                        setState(() {
                          primaryFocus!.unfocus(disposition: disposition);
                        });
                        _presentDatePicker();
                      },
                      icon: const Icon(Icons.calendar_today),
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            //Next Button
            if (_selectedOption == 'amount')
              if (Platform.isIOS)
                CupertinoButton.filled(
                  onPressed: () {
                    primaryFocus!.unfocus(disposition: disposition);
                    _nextStep();
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    primaryFocus!.unfocus(disposition: disposition);
                    _nextStep();
                  },
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
            //Save button
            if (_selectedOption != 'amount')
              if (Platform.isIOS)
                CupertinoButton.filled(
                  onPressed: () {
                    _submitData();
                  },
                  child: (saving)
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
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
                  child: (saving)
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Save Expense',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                ),
            const SizedBox(
              height: 16,
            ),
            if (_selectedOption == 'category')
              if (categories.isEmpty)
                const Center(
                  heightFactor: 5,
                  child: Column(
                    children: [
                      Text('No categories found'),
                    ],
                  ),
                )
              else
                CategorySelectGrid(
                    categories: categories,
                    selectedCategory: _selectedCategory,
                    selectedSubCategory: _selectedSubCategory,
                    subcategories: _selectedCategory?.subcategories ?? [],
                    onSubCategorySelected: (subcategory) {
                      setState(() {
                        _selectedSubCategory = subcategory;
                        _selectedOption = 'account';
                      });
                    },
                    onCategorySelected: (category) {
                      setState(() {
                        _selectedSubCategory = '';
                        _selectedCategory = category;
                      });
                    }),
            if (_selectedOption == 'account')
              if (accounts.isEmpty)
                const Center(
                  heightFactor: 5,
                  child: Column(
                    children: [
                      Text('No accounts found'),
                    ],
                  ),
                )
              else
                AccountSelectGrid(
                    accounts: accounts,
                    selectedAccount: _selectedAccount,
                    onAccountSelected: (account) {
                      setState(() {
                        _selectedAccount = account;
                        _selectedOption = '';
                      });
                    }),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
