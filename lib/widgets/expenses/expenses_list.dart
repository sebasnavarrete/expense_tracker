import 'package:expense_tracker/widgets/expenses/expense_item.dart';
import 'package:expense_tracker/models/expese.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList({
    super.key,
    required this.expenses,
    required this.onRemoveExpense,
    required this.onEditExpense,
  });

  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;
  final void Function(Expense expense) onEditExpense;

  String getDayOfWeek(String date) {
    final dateF = DateFormat('dd-MM-yyyy').parse(date);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final difference = today.difference(dateF).inDays;
    if (dateF == today) {
      return 'Today';
    } else if (dateF == yesterday) {
      return 'Yesterday';
    } else if (difference < 7) {
      return DateFormat('EEEE').format(dateF);
    }
    return DateFormat.yMMMMd('en_US').format(dateF);
  }

  //get total expenses per group
  double getTotalExpenses(List<Expense> expenses) {
    double total = 0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    expenses.sort((a, b) => b.date.compareTo(a.date));
    final groupedExpenses = ExpenseList(expenses).groupedExpenses;

    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...groupedExpenses.entries.map((group) {
              final expensesG = group.value;
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${getDayOfWeek(group.key)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const Spacer(),
                          Text(
                            '\$${getTotalExpenses(expensesG).toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    ),
                    ...expensesG.map((expense) {
                      return Dismissible(
                        key: ValueKey(expense.id),
                        background: Container(
                          color: Theme.of(context).colorScheme.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 8),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        onDismissed: (direction) {
                          onRemoveExpense(expense);
                        },
                        child: InkWell(
                          onTap: () {
                            onEditExpense(expense);
                          },
                          child: ExpenseItem(
                            expense,
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
