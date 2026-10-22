import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:money_matters/models/transaction_model.dart';
import 'package:money_matters/models/budget_model.dart';
import 'package:money_matters/services/app_data.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(

    'Cloud Sync',

    () {

      testWidgets(

        'Local state survives backup restore simulation',

        (tester) async {

          // Arrange

          AppData.transactions.clear();

          AppData.budgets.clear();

          AppData.transactions.add(

            TransactionModel(

              id: 'sync-test',

              amount: 1234,

              category: 'Food',

              account: 'Cash',

              description: 'Cloud Sync Test',

              type: 'Expense',

              date: DateTime.now(),

            ),

          );

          AppData.budgets.add(

            BudgetModel(

              category: 'Food',

              monthlyBudget: 5000,

              savings: 0,

              debt: 0,

              carryForward: true,

              startMonth: 6,

              startYear: 2026,

            ),

          );

          // Simulate backup snapshot

          final txBackup =

List<TransactionModel>.from(
AppData.transactions,
);

final budgetBackup =

List<BudgetModel>.from(
AppData.budgets,
);

          // Simulate app wipe

          AppData.transactions.clear();

          AppData.budgets.clear();

          expect(
            AppData.transactions.isEmpty,
            true,
          );

          expect(
            AppData.budgets.isEmpty,
            true,
          );

          // Simulate restore

          AppData.transactions.addAll(
            txBackup,
          );

          AppData.budgets.addAll(
            budgetBackup,
          );

          // Verify

          expect(
            AppData.transactions.length,
            1,
          );

          expect(
            AppData.transactions.first.amount,
            1234,
          );

          expect(
            AppData.transactions.first.description,
            'Cloud Sync Test',
          );

          expect(
            AppData.budgets.length,
            1,
          );

          expect(
            AppData.budgets.first.monthlyBudget,
            5000,
          );

        },

      );

    },

  );

}
