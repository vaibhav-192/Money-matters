import 'package:flutter/material.dart';

import '../../../services/analytics_service.dart';
import '../../../services/app_data.dart';

class CategoryBreakdown extends StatelessWidget {
  const CategoryBreakdown({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = AnalyticsService.categoryExpenses;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Text(
              "Spending by Category",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            if (categories.isEmpty)

              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "No expense transactions this month.",
                  ),
                ),
              )

            else

              ...categories.map(

                (entry) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [

                      Expanded(
                        child: Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),

                      Text(
                        "${AppData.currency}${entry.value.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),

              ),

          ],
        ),
      ),
    );
  }
}