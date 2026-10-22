import 'package:flutter/material.dart';

import '../features/dashboard/dashboard_screen.dart';
import '../features/transactions/transactions_screen.dart';
import '../features/budget/budget_screen.dart';
import '../features/reports/reports_screen.dart';
import '../features/accounts/accounts_screen.dart';
import '../features/recurring/recurring_screen.dart';

class NavigationScreen
    extends StatefulWidget {

  const NavigationScreen({
    super.key,
  });

  @override
  State<NavigationScreen>
      createState()

          =>

          _NavigationScreenState();

}

class _NavigationScreenState
    extends State<
        NavigationScreen> {

  int currentIndex = 0;

  final screens = [

    const DashboardScreen(),

    const TransactionsScreen(),

    const BudgetScreen(),

    const ReportsScreen(),

    const RecurringScreen(),

    const AccountsScreen(),

  ];

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      body:
          screens[
              currentIndex],

      bottomNavigationBar:

          BottomNavigationBar(

        currentIndex:
            currentIndex,

        type:
            BottomNavigationBarType.fixed,

        onTap:

            (index) {

          setState(() {

            currentIndex =
                index;

          });

        },

        items: const [

          BottomNavigationBarItem(

            icon:
                Icon(
              Icons.home,
            ),

            label:
                "Home",

          ),

          BottomNavigationBarItem(

            icon:
                Icon(
              Icons.receipt,
            ),

            label:
                "Transactions",

          ),

          BottomNavigationBarItem(

            icon:
                Icon(
              Icons.savings,
            ),

            label:
                "Budget",

          ),

          BottomNavigationBarItem(

            icon:
                Icon(
              Icons.bar_chart,
            ),

            label:
                "Reports",

          ),

          BottomNavigationBarItem(

            icon:
                Icon(
              Icons.repeat,
            ),

            label:
                "Recurring",

          ),

          BottomNavigationBarItem(

            icon:
                Icon(
              Icons.account_balance,
            ),

            label:
                "Accounts",

          ),

        ],

      ),

    );

  }

}