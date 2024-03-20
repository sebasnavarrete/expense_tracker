import 'package:expense_tracker/services/expense_service.dart';
import 'package:expense_tracker/widgets/expenses/expenses_list.dart';
import 'package:expense_tracker/widgets/expenses/expense_form.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/providers/expenses.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  late Future<void> _expensesFuture;

  @override
  void initState() {
    super.initState();
    _expensesFuture = ref.read(expensesProvider.notifier).getExpenses();
  }

  void _openExpenseForm(Expense expense) {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return ExpenseForm(expense: expense);
        });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = ref.read(expensesProvider.notifier).getIndex(expense);
    ref.read(expensesProvider.notifier).removeExpense(expense);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: const Text('Expense removed'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                setState(() {
                  ref
                      .read(expensesProvider.notifier)
                      .addExpenseIndex(expense, expenseIndex);
                });
              },
            ),
          ),
        )
        .closed
        .then((reason) async {
      if (reason != SnackBarClosedReason.action) {
        final response = await ExpenseService().removeExpense(expense);
        if (response.statusCode >= 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to remove expense'),
            ),
          );
          ref
              .read(expensesProvider.notifier)
              .addExpenseIndex(expense, expenseIndex);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Expense> registeredExpenses = ref.watch(expensesProvider);

    final defaultExpense = Expense(
      amount: 0,
      date: DateTime.now(),
      category: null,
      account: null,
    );

    Widget mainContent = const Center(
      child: Text('No expenses yet'),
    );

    if (registeredExpenses.isNotEmpty) {
      mainContent = FutureBuilder(
        future: _expensesFuture,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : ExpensesList(
                    expenses: registeredExpenses,
                    onRemoveExpense: _removeExpense,
                    onEditExpense: _openExpenseForm,
                  ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: mainContent,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openExpenseForm(defaultExpense),
        child: const Icon(Icons.add),
      ),
    );
  }
}
