import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:money_matters/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Analytics screen renders',
    (tester) async {
      app.main();

      await tester.pumpAndSettle(
        const Duration(seconds: 5),
      );

      expect(
        find.byType(Scaffold),
        findsWidgets,
      );
    },
  );
}