import 'package:expense_tracker/helpers/helper.dart';
import 'package:expense_tracker/widgets/expenses/expense_item.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class MonthlyReport extends StatefulWidget {
  const MonthlyReport({super.key, required this.expenses});

  final List<Expense> expenses;

  @override
  _MonthlyReportState createState() => _MonthlyReportState();
}

//linechart data
class _MonthlyReportState extends State<MonthlyReport> {
  //get total expenses per group
  double getTotalExpenses(List<Expense> expenses) {
    double total = 0;
    for (final expense in expenses) {
      total += expense.amount;
    }
    return total;
  }

  Widget build(BuildContext context) {
    widget.expenses.sort((a, b) => b.date.compareTo(a.date));
    final monthlyExpenses = ExpenseList(widget.expenses).monthlyExpenses;
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...monthlyExpenses.entries.map((group) {
                final expensesG = group.value;
                final catExpenses = ExpenseList(expensesG).expensesByCategory;
                return Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              group.key,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                            ),
                            const Spacer(),
                            Text(
                              Helper()
                                  .formatCurrency(getTotalExpenses(expensesG)),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                      ),
                      Column(
                        children: [
                          ...catExpenses.entries.map((catGroup) {
                            final catExpensesG = catGroup.value;
                            return ExpansionTile(
                              tilePadding:
                                  const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              title: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    catGroup.key,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    Helper().formatCurrency(
                                        getTotalExpenses(catExpensesG)),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                  ),
                                ],
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              children: <Widget>[
                                ...catExpensesG.map((expense) {
                                  return Dismissible(
                                    key: ValueKey(expense.id),
                                    direction: DismissDirection.endToStart,
                                    background: Container(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 8),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                    child: InkWell(
                                      child: ExpenseItem(
                                        expense,
                                        showDate: true,
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            );
                          }),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
