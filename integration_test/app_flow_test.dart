import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:money_matters/main.dart' as app;

void main() {

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(

    'App starts without crash',

    (tester) async {

      app.main();

      await tester.pumpAndSettle(
        const Duration(
          seconds: 10,
        ),
      );

      expect(

        tester.takeException(),

        isNull,

      );

    },

  );

}