import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:money_matters/models/budget_model.dart';
import 'package:money_matters/services/app_data.dart';

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(

    'Budget Timeline',

    () {

      testWidgets(

        'Editing future budget does not affect history',

        (tester) async {

          AppData.budgets.clear();

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

          final old =

              AppData.budgets.first;

          old.endMonth = 8;

          old.endYear = 2026;

          AppData.budgets.add(

            BudgetModel(

              category: 'Food',

              monthlyBudget: 500,

              savings: 0,

              debt: 0,

              carryForward: true,

              startMonth: 9,

              startYear: 2026,

            ),

          );

          expect(

            AppData.budgets.length,

            2,

          );

          expect(

            AppData.budgets[0].monthlyBudget,

            5000,

          );

          expect(

            AppData.budgets[1].monthlyBudget,

            500,

          );

        },

      );

    },

  );

}