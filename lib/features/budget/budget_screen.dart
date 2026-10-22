import 'package:flutter/material.dart';

import '../../models/budget_model.dart';
import '../../services/app_data.dart';

class BudgetScreen extends StatefulWidget {

  const BudgetScreen({
    super.key,
  });

  @override
  State<BudgetScreen> createState() =>
      _BudgetScreenState();

}

class _BudgetScreenState
    extends State<BudgetScreen> {
      int selectedMonth =
    DateTime.now().month;
static const monthNames = [

"January",

"February",

"March",

"April",

"May",

"June",

"July",

"August",

"September",

"October",

"November",

"December",

];
int selectedYear =
    DateTime.now().year;

  Future openAdd()
  async {

    final categories =

        AppData.categories

            .where(
              (e) =>
                  e.type ==
                  "Expense",
            )

            .toList();

    if (
        categories.isEmpty
    ) return;

    String selected =
        categories.first.name;

    final amount =
        TextEditingController();
    int startMonth =
DateTime.now().month;

int startYear =
DateTime.now().year;

    await showDialog(

      context:
          context,

      builder:
          (_) {

        return AlertDialog(

          title:

              const Text(
            "Create Budget",
          ),

          content:

Column(

mainAxisSize:
MainAxisSize.min,

children:[

DropdownButtonFormField<String>(

value:
selected,

decoration:

const InputDecoration(

labelText:
"Category",

),

items:

categories

.map(

(e)=>

DropdownMenuItem(

value:
e.name,

child:

Text(
e.name,
),

),

)

.toList(),

onChanged:

(v){

selected =
v!;

},

),

const SizedBox(
height:
12,
),

TextField(

controller:
amount,

keyboardType:
TextInputType.number,

decoration:

InputDecoration(

labelText:
"Budget Amount",

prefixText:
"${AppData.currency} ",

),

),

const SizedBox(
height:
12,
),

DropdownButtonFormField<int>(

value:
startMonth,

decoration:

const InputDecoration(

labelText:
"Start Month",

),

items:

List.generate(

12,

(i)=>

DropdownMenuItem(

value:
i+1,

child:

Text(
monthNames[i],
),

),

),

onChanged:

(v){

startMonth =
v!;

},

),

const SizedBox(
height:
12,
),

DropdownButtonFormField<int>(

value:
startYear,

decoration:

const InputDecoration(

labelText:
"Start Year",

),

items:

[

2025,
2026,
2027,
2028,

]

.map(

(e)=>

DropdownMenuItem(

value:
e,

child:

Text(
"$e",
),

),

)

.toList(),

onChanged:

(v){

startYear =
v!;

},

),

],
),

          actions: [

            ElevatedButton(

              onPressed:
                  () {

                AppData.budgets.add(

                  BudgetModel(

                    category:
                        selected,

                    startMonth:
                        startMonth,

                    startYear:
                        startYear,

                    monthlyBudget:

                        double.tryParse(
                              amount.text,
                            )
                            ??
                            0,

                  ),

                );

                AppData.save();

                Navigator.pop(
                  context,
                );

                setState(() {});

              },

              child:

                  const Text(
                "Save",
              ),

            ),

          ],

        );

      },

    );

  }

  double spent(
  BudgetModel b,
) {

  final month =
    selectedMonth;

final year =
    selectedYear;

  double total = 0;

  for (

    final t

    in

    AppData.transactions

  ) {

    t.date.month
            ==
            month;

    t.date.year
            ==
            year;

    if (

      t.type
              ==
              "Expense"

          &&

          t.category
              ==
              b.category

          &&

          t.date.month
==
month

&&

t.date.year
==
year

    ) {

      total +=
          t.amount;

    }

  }

  return total;

}

double globalSavings() {

double pool = 0;

final month =
selectedMonth;

final year =
selectedYear;

final active =

<BudgetModel>[];

for (

final b

in

AppData.budgets

) {

final afterStart =

year >

b.startYear

||

(

year
==
b.startYear

&&

month
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

year
<
b.endYear!

||

(

year
==
b.endYear!

&&

month
<=
b.endMonth!

);

if (

afterStart

&&

beforeEnd

) {

active.add(
b,
);

}

}

for (

final b

in

active

) {

double used = 0;

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

t.category
==
b.category

&&

t.date.month
==
month

&&

t.date.year
==
year

) {

used +=
t.amount;

}

}

pool +=

(

b.monthlyBudget
-
used

)

.clamp(
0,
999999999,
);

}

return pool;

}

double debt(
  BudgetModel b,
) {

  final extra =

      spent(
        b,
      )

      -

      b.monthlyBudget;

  if (

    extra
    <=
    0

  ) {

    return 0;

  }

  final remaining =

      extra
      -
      globalSavings();

  return remaining > 0
      ? remaining
      : 0;

}

double available(
BudgetModel b,
) {

final budget =

AppData.effectiveBudget(

b.monthlyBudget,

);

return (

budget

-

spent(
b,
)

)

.clamp(
0,
999999999,
);

}

  @override
  Widget build(
      BuildContext context) {
    
    final Map<String,BudgetModel>
latest = {};

for (

final b

in

AppData.budgets

) {

final afterStart =

selectedYear >

b.startYear

||

(

selectedYear
==
b.startYear

&&

selectedMonth
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

selectedYear
<
b.endYear!

||

(

selectedYear
==
b.endYear!

&&

selectedMonth
<=
b.endMonth!

);

final active =

afterStart

&&

beforeEnd;

if (
!active
){

continue;

}

if (

!latest.containsKey(
b.category,
)

) {

latest[
b.category
] =
b;

continue;

}

final old =
latest[
b.category
]!;

final newer =

b.startYear
>
old.startYear

||

(

b.startYear
==
old.startYear

&&

b.startMonth
>
old.startMonth

);

if (

newer

) {

latest[
b.category
] =
b;

}

}

final visibleBudgets =

latest.values.toList();

    return Scaffold(

      appBar:

          AppBar(

        title:

            const Text(
          "Budgets",
        ),

      ),

      floatingActionButton:

          FloatingActionButton(

        onPressed:
            openAdd,

        child:

            const Icon(
          Icons.add,
        ),

      ),
body:

Column(

children: [

Padding(

padding:
const EdgeInsets.all(
12,
),

child:

Row(

children: [

Expanded(

child:

DropdownButtonFormField<int>(

value:
selectedMonth,

decoration:

const InputDecoration(

labelText:
"Month",

),

items:

List.generate(

12,

(i) =>

DropdownMenuItem<int>(

value:
i + 1,

child:

Text(
monthNames[i],
),

),

).toList(),

onChanged:

(v) {

if (
v == null
) return;

setState(() {

selectedMonth =
v;

});

},

),

),

const SizedBox(
width:
10,
),

Expanded(

child:

DropdownButtonFormField<int>(

value:
selectedYear,

decoration:

const InputDecoration(

labelText:
"Year",

),

items:

[

DateTime.now().year,

]

.map(

(e)

=>

DropdownMenuItem<int>(

value:
e,

child:
Text(
"$e",
),

),

)

.toList(),

onChanged:

(v) {

if (
v == null
) return;

setState(() {

selectedYear =
v;

});

},

),

),

],

),

),

Padding(

padding:

const EdgeInsets.symmetric(

horizontal:
12,

),

child:

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

style:

TextStyle(

fontWeight:
FontWeight.bold,

),

),

const SizedBox(
height:
8,
),

Text(

"${AppData.currency}${AppData.globalSavings.toStringAsFixed(0)}",

style:

const TextStyle(

fontSize:
22,

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
12,
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

style:

TextStyle(

fontWeight:
FontWeight.bold,

),

),

const SizedBox(
height:
8,
),

Text(

"${AppData.currency}${AppData.globalDebt.toStringAsFixed(0)}",

style:

const TextStyle(

fontSize:
22,

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

),

const SizedBox(
height:
12,
),

Expanded(

child:

AppData.budgets.isEmpty

?

const Center(

child:

Text(
"No Budgets",
),

)

:

ListView.builder(

itemCount:
visibleBudgets.length,

itemBuilder:
(
context,
index,
) {

final b =
visibleBudgets[index];

final used =
spent(
b,
);

final progress =

b.monthlyBudget == 0

?

0.0

:

used /

AppData.effectiveBudget(

b.monthlyBudget,

);

return Card(

margin:

const EdgeInsets.all(
10,
),

child:

ListTile(

title:

Text(
b.category,
),

subtitle:

Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

Text(
"Budget ${AppData.currency}${AppData.effectiveBudget(b.monthlyBudget).toStringAsFixed(0)}",
),

Text(
"Spent ${AppData.currency}${used.toStringAsFixed(0)}",
),

Text(
"Debt ${AppData.currency}${debt(b).toStringAsFixed(0)}",
),

Text(
"Available ${AppData.currency}${available(b).toStringAsFixed(0)}",
),

const SizedBox(
height:
8,
),

LinearProgressIndicator(

value:

progress.clamp(
0,
1,
),

),

],

),
trailing:

PopupMenuButton<String>(

onSelected:

(v){

if (

v
==
"edit"

) {

final controller =

TextEditingController(

text:

b.monthlyBudget
.toString(),

);

showDialog(

context:
context,

builder:
(_){

return AlertDialog(

title:

const Text(
"Edit Budget",
),

content:

TextField(

controller:
controller,

keyboardType:
TextInputType.number,

decoration:

InputDecoration(

labelText:
"New Budget",

prefixText:
"${AppData.currency} ",

),

),

actions:[

ElevatedButton(

onPressed:(){

final value =

double.tryParse(
controller.text,
);

if(
value
==
null
){

return;

}

final now =
DateTime.now();

final previousMonth =

now.month == 1

?

12

:

now.month - 1;

final previousYear =

now.month == 1

?

now.year - 1

:

now.year;

b.endMonth =
previousMonth;

b.endYear =
previousYear;

AppData.budgets.add(

BudgetModel(

category:
b.category,

monthlyBudget:
value,

startMonth:
now.month,

startYear:
now.year,

endMonth:
null,

endYear:
null,

savings:
b.savings,

debt:
b.debt,

carryForward:
b.carryForward,

),

);

AppData.save();

Navigator.pop(
context,
);

setState(() {});

},

child:

const Text(
"Save",
),

),

],

);

},

);

}

else if (

v
==
"delete"

) {

AppData.budgets.remove(

b,

);

AppData.save();

setState(() {});

}

},

itemBuilder:

(_)=>[

const PopupMenuItem(

value:
"edit",

child:

Text(
"Edit",
),

),

const PopupMenuItem(

value:
"delete",

child:

Text(
"Delete",
),

),

],

),

),

);

},
),

),

],

),

    );

  }

}