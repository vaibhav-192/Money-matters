import 'package:flutter/material.dart';
import 'widgets/category_breakdown.dart';
import '../../services/analytics_service.dart';
import '../../services/app_data.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  Widget buildCard(
    BuildContext context, {
    required String title,
    required String value,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final largestExpense = AnalyticsService.largestExpense;
    final largestIncome = AnalyticsService.largestIncome;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Analytics"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          buildCard(
            context,
            title: "Income (This Month)",
            value:
                "${AppData.currency}${AnalyticsService.totalIncome.toStringAsFixed(2)}",
          ),

          buildCard(
            context,
            title: "Expense (This Month)",
            value:
                "${AppData.currency}${AnalyticsService.totalExpense.toStringAsFixed(2)}",
          ),

          buildCard(
            context,
            title: "Savings",
            value:
                "${AppData.currency}${AnalyticsService.savings.toStringAsFixed(2)}",
          ),

          buildCard(
            context,
            title: "Transactions",
            value:
                AnalyticsService.transactionCount.toString(),
          ),

          buildCard(
            context,
            title: "Largest Expense",
            value: largestExpense == null
                ? "-"
                : "${AppData.currency}${largestExpense.amount.toStringAsFixed(2)}",
          ),

          buildCard(
            context,
            title: "Largest Income",
            value: largestIncome == null
                ? "-"
                : "${AppData.currency}${largestIncome.amount.toStringAsFixed(2)}",
          ),
          const CategoryBreakdown(),
        ],
      ),
    );
  }
}