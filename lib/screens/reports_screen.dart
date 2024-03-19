import 'package:expense_tracker/models/expese.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracker/providers/expenses.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Expense> registeredExpenses = ref.watch(expensesProvider);
    return Scaffold(
      body: Column(
        children: [
          Chart(expenses: registeredExpenses),
        ],
      ),
    );
  }
}
