import 'package:flutter/material.dart';
import '../analytics/analytics_screen.dart';
import '../../services/app_data.dart';
import '../transactions/add_transaction_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  double get income {

double value = 0;

for (

var t

in

AppData.transactions

) {

if (

t.type

==

"Income"

) {

value += t.amount;

}

}

return value;

}

double get expense {

double value = 0;

for (

var t

in

AppData.transactions

) {

if (

t.type

==

"Expense"

) {

value += t.amount;

}

}

return value;

}

double get total {

return income - expense;

}

  double get monthBudget {

final latest =

<String,double>{};

final now =
DateTime.now();

for (

final b

in

AppData.budgets

) {

final afterStart =

now.year
>
b.startYear

||

(

now.year
==
b.startYear

&&

now.month
>=
b.startMonth

);

final beforeEnd =

b.endMonth
==
null

||

b.endYear
==
null

||

now.year
<
b.endYear!

||

(

now.year
==
b.endYear!

&&

now.month
<=
b.endMonth!

);

if (

!(

afterStart

&&

beforeEnd

)

) {

continue;

}

latest[
b.category
] =

AppData.effectiveBudget(

b.monthlyBudget,

);

}

return

latest.values.fold(

0.0,

(a,b)=>a+b,

);

}

double get monthSpent {

double total = 0;

for (

final t

in

AppData.transactions

) {

if (

t.type
==
"Expense"

&&

t.date.month
==
DateTime.now().month

&&

t.date.year
==
DateTime.now().year

) {

total +=
t.amount;

}

}

return total;

}

double get remainingBudget {

return (

monthBudget
-
monthSpent

)

.clamp(
0,
999999999,
);

}
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: Padding(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              const SizedBox(
                height: 20,
              ),

              Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [

    const Text(
      "Money Matters",
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
    ),

    Row(
      mainAxisSize: MainAxisSize.min,
      children: [

        IconButton(
          icon: const Icon(Icons.analytics_outlined),
          tooltip: "Analytics",
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AnalyticsScreen(),
              ),
            );
          },
        ),

        IconButton(
          icon: const Icon(Icons.settings),
          tooltip: "Settings",
          onPressed: () {
            Navigator.pushNamed(
              context,
              "/settings",
            );
          },
        ),

      ],
    ),

  ],
),

              const SizedBox(
                height: 30,
              ),

              Container(

                width:
                    double.infinity,

                padding:
                    const EdgeInsets.all(
                        20),

                decoration:
                    BoxDecoration(

                  color:
                      Colors.blue,

                  borderRadius:
                      BorderRadius.circular(
                          20),
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    const Text(
                      "Total Balance",
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(

                      "${AppData.currency}${total.toStringAsFixed(0)}",

                      style:
                          const TextStyle(

                        fontSize:
                            38,

                        color:
                            Colors.white,
                      ),
                    ),
                    const SizedBox(
height: 20,
),

Row(

children: [

Expanded(

child:

Card(

child:

Padding(

padding:
EdgeInsets.all(
16,
),

child:

Column(

children: [

Text(
"Income",
),

SizedBox(
height:
10,
),

Text(
"${AppData.currency}${income.toStringAsFixed(0)}",
),

],

),

),

),

),

SizedBox(
width:
10,
),

Expanded(

child:

Card(

child:

Padding(

padding:
EdgeInsets.all(
16,
),

child:

Column(

children: [

Text(
"Expense",
),

SizedBox(
height:
10,
),

Text(
"${AppData.currency}${expense.toStringAsFixed(0)}",
),

],

),

),

),

),

],

),
const SizedBox(
height:
12,
),

Row(

children: [

Expanded(

child:

Card(

child:

Padding(

padding:

const EdgeInsets.all(
16,
),

child:

Column(

children: [

const Text(

"Global Savings",

),

const SizedBox(
height:
10,
),

Text(

"${AppData.currency}${AppData.globalSavings.toStringAsFixed(0)}",

style:

const TextStyle(

fontSize:
20,

color:
Colors.green,

),

),

],

),

),

),

),

const SizedBox(
width:
10,
),

Expanded(

child:

Card(

child:

Padding(

padding:

const EdgeInsets.all(
16,
),

child:

Column(

children: [

const Text(

"Global Debt",

),

const SizedBox(
height:
10,
),

Text(

"${AppData.currency}${AppData.globalDebt.toStringAsFixed(0)}",

style:

const TextStyle(

fontSize:
20,

color:
Colors.red,

),

),

],

),

),

),

),

],

),

                  ],
                ),
              ),
              Card(

child:

Padding(

padding:

const EdgeInsets.all(
16,
),

child:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

const Text(

"Monthly Budget",

style:

TextStyle(

fontWeight:
FontWeight.bold,

fontSize:
18,

),

),

const SizedBox(
height:
12,
),

Text(
"Budget ${AppData.currency}${monthBudget.toStringAsFixed(0)}",
),

Text(
"Spent ${AppData.currency}${monthSpent.toStringAsFixed(0)}",
),

Text(
"Remaining ${AppData.currency}${remainingBudget.toStringAsFixed(0)}",
),

const SizedBox(
height:
10,
),

LinearProgressIndicator(

value:

monthBudget
==
0

?

0

:

(

monthSpent
/
monthBudget

)

.clamp(
0,
1,
),

),

],

),

),

),

const SizedBox(
height:
20,
),
              const SizedBox(
  height: 20,
),

const Text(
  "Accounts",
),

const SizedBox(
  height: 10,
),

Expanded(
  child:
      ListView.builder(

    itemCount:
        AppData
            .accounts
            .length,

    itemBuilder:
        (
      context,
      index,
    ) {

      final acc =
          AppData.accounts[
              index];

      return ListTile(

        title:
            Text(
          acc.name,
        ),

        trailing:
            Text(
          "${AppData.currency}${acc.balance}",
        ),
      );
    },
  ),
),
            ],
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton(

        onPressed: () async {

          await Navigator.push(

            context,

            MaterialPageRoute(

              builder:
                  (_)

                      =>

                  const AddTransactionScreen(),
            ),
          );

          setState(() {});
        },

        child:
            const Icon(
          Icons.add,
        ),
      ),
    );
  }
}