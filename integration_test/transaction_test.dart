import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:money_matters/models/transaction_model.dart';
import 'package:money_matters/services/app_data.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(

    'Transaction Flow',

    () {

      testWidgets(

        'Add Edit Delete Transaction',

        (tester) async {

          AppData.transactions.clear();

          AppData.transactions.add(

            TransactionModel(

              id: 'test-1',

              amount: 500,

              category: 'Food',

              account: 'Cash',

              description: 'Lunch',

              type: 'Expense',

              date: DateTime.now(),

            ),

          );

          expect(
            AppData.transactions.length,
            1,
          );

          expect(
            AppData.transactions.first.amount,
            500,
          );

          AppData.transactions[0] =

              TransactionModel(

                id: 'test-1',

                amount: 700,

                category: 'Food',

                account: 'Cash',

                description: 'Lunch Updated',

                type: 'Expense',

                date: DateTime.now(),

              );

          expect(

            AppData.transactions.first.amount,

            700,

          );

          AppData.transactions.removeAt(
            0,
          );

          expect(

            AppData.transactions.isEmpty,

            true,

          );

        },

      );

    },

  );

}