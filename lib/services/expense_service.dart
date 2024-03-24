import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:sentry/sentry.dart';

class ExpenseService {
  User? user = FirebaseAuth.instance.currentUser;

  Future<dynamic> getExpenses() async {
    try {
      final expensesData = await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('expenses')
          .get();
      return expensesData;
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
    }
  }

  Future<http.Response> addExpense(Expense expense) async {
    try {
      final process = await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('expenses')
          .add({
        'amount': expense.amount,
        'date': expense.date.toIso8601String(),
        'category': expense.category!.id,
        'account': expense.account!.id,
        'notes': expense.notes,
      });

      return http.Response(process.id, 200);
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to add expense', 500);
    }
  }

  Future<http.Response> updateExpense(Expense expense) async {
    try {
      await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('expenses')
          .doc(expense.id)
          .update({
        'amount': expense.amount,
        'date': expense.date.toIso8601String(),
        'category': expense.category!.id,
        'account': expense.account!.id,
        'notes': expense.notes,
      });

      return http.Response('Expense updated', 200);
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to update expense', 500);
    }
  }

  Future<http.Response> removeExpense(Expense expense) async {
    try {
      await FirebaseFirestore.instance
          .collection(user!.uid)
          .doc('expenses')
          .collection('expenses')
          .doc(expense.id)
          .delete();

      return http.Response('Expense removed', 200);
    } catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      return http.Response('Failed to remove expense', 500);
    }
  }
}
