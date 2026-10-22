import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:money_matters/models/transaction_model.dart';
import 'package:money_matters/services/app_data.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(

    'Backup Restore',

    () {

      testWidgets(

        'Transactions survive restore',

        (tester) async {

          AppData.transactions.clear();

          AppData.transactions.add(

            TransactionModel(

              id: 'cloud-test',

              amount: 777,

              category: 'Food',

              account: 'Cash',

              description: 'Cloud Test',

              type: 'Expense',

              date: DateTime(
                2026,
                6,
                14,
              ),

            ),

          );

          expect(

            AppData.transactions.length,

            1,

          );

          expect(

            AppData.transactions.first.amount,

            777,

          );

          expect(

            AppData.transactions.first.description,

            'Cloud Test',

          );

        },

      );

    },

  );

}