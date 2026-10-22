import 'package:flutter/material.dart';
import 'services/recurring_data.dart';
import 'core/navigation_screen.dart';
import 'database/storage_service.dart';
import 'services/app_data.dart';
import 'services/recurring_engine.dart';
import 'features/settings/settings_screen.dart';
import 'services/sync_service.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding
      .ensureInitialized();

  await StorageService.init();

await Firebase.initializeApp(

options:

DefaultFirebaseOptions.currentPlatform,

);

AppData.load();

RecurringData.load();

RecurringEngine.run();
  await SyncService.sync();

  runApp(
    const MoneyMattersApp(),
  );
}

class MoneyMattersApp
    extends StatelessWidget {

  const MoneyMattersApp({
    super.key,
  });

  @override
  Widget build(
      BuildContext context) {

    return MaterialApp(

debugShowCheckedModeBanner:
false,

title:
'Money Matters',

theme:

AppData.darkMode

?

ThemeData.dark()

:

ThemeData.light(),

routes: {

"/settings":

(_)

=>

const SettingsScreen(),

},

home:

const NavigationScreen(),

);
  }
}