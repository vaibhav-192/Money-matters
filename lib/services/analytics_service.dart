import '../models/transaction_model.dart';
import 'app_data.dart';

class AnalyticsService {
  static List<TransactionModel> get _currentMonthTransactions {
    final now = DateTime.now();

    return AppData.transactions.where((tx) {
      return tx.date.year == now.year &&
          tx.date.month == now.month;
    }).toList();
  }

  static double get totalIncome {
    return _currentMonthTransactions
        .where((t) => t.type == "Income")
        .fold(
          0.0,
          (sum, t) => sum + t.amount,
        );
  }

  static double get totalExpense {
    return _currentMonthTransactions
        .where((t) => t.type == "Expense")
        .fold(
          0.0,
          (sum, t) => sum + t.amount,
        );
  }

  static double get savings {
    return totalIncome - totalExpense;
  }

  static int get transactionCount {
    return _currentMonthTransactions.length;
  }

  static TransactionModel? get largestExpense {
    final expenses = _currentMonthTransactions
        .where((t) => t.type == "Expense")
        .toList();

    if (expenses.isEmpty) return null;

    expenses.sort(
      (a, b) => b.amount.compareTo(a.amount),
    );

    return expenses.first;
  }

  static TransactionModel? get largestIncome {
    final incomes = _currentMonthTransactions
        .where((t) => t.type == "Income")
        .toList();

    if (incomes.isEmpty) return null;

    incomes.sort(
      (a, b) => b.amount.compareTo(a.amount),
    );

    return incomes.first;
  }
  static List<MapEntry<String, double>> get categoryExpenses {

  final Map<String, double> totals = {};

  for (final tx in _currentMonthTransactions) {

    if (tx.type != "Expense") continue;

    totals.update(
      tx.category,
      (value) => value + tx.amount,
      ifAbsent: () => tx.amount,
    );
  }

  final result = totals.entries.toList();

  result.sort(
    (a, b) => b.value.compareTo(a.value),
  );

  return result;
}
}