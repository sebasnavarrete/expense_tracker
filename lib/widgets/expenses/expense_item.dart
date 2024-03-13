import 'package:expense_tracker/models/expese.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense, {super.key});

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Icon(
              IconData(expense.category.icon, fontFamily: 'MaterialIcons'),
              size: 16.0,
            ),
            const SizedBox(width: 4.0),
            Text(expense.category.name.toUpperCase()),
          ],
        ),
        subtitle: Row(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${expense.amount.toStringAsFixed(2)}',
                  //style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  ' ${expense.account.name.toUpperCase()}',
                  style: const TextStyle(
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(expense.formattedDate),
          ],
        ),
      ),
    );
  }
}
