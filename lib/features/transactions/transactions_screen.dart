import 'package:flutter/material.dart';
import '../categories/category_screen.dart';
import '../../services/app_data.dart';
import 'edit_transaction_screen.dart';

class TransactionsScreen extends StatefulWidget {

  const TransactionsScreen({
    super.key,
  });

  @override
  State<TransactionsScreen> createState()

      =>

      _TransactionsScreenState();

}

class _TransactionsScreenState
    extends State<TransactionsScreen> {

  String selectedCategory =
"All";

  String selectedYear = "All";

  String selectedMonth = "All";

  String selectedAccount = "All";

  String selectedType = "All";
  static const months = [

"All",

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

  String sort = "Latest";

  Future openEdit(
      int index)
  async {

    final updated =

        await Navigator.push(

      context,

      MaterialPageRoute(

        builder:
            (_)

                =>

                EditTransactionScreen(

          transaction:

              AppData
                  .transactions[index],

        ),

      ),

    );

    if (
        updated ==
        true
    ) {

      setState(() {});

    }

  }

  List filtered() {

    var tx =

        [...AppData.transactions];

    if (

selectedMonth
!=
"All"

) {

final month =

months.indexOf(
selectedMonth,
);

tx =

tx.where(

(e)=>

e.date.month
==
month,

)

.toList();

}

if (

selectedYear
!=
"All"

) {

tx =

tx.where(

(e)=>

e.date.year
.toString()

==

selectedYear,

)

.toList();

}

if (

selectedYear
!=
"All"

) {

tx =

tx.where(

(e)=>

e.date.year
.toString()

==

selectedYear,

)

.toList();

}

    if (

      selectedAccount
      !=
      "All"

    ) {

      tx = tx.where(

        (e)

            =>

            e.account
            ==
            selectedAccount,

      ).toList();

    }
    if (

selectedCategory
!=
"All"

) {

tx =

tx.where(

(e)

=>

e.category
==
selectedCategory,

)

.toList();

}

    if (

      selectedType
      !=
      "All"

    ) {

      tx = tx.where(

        (e)

            =>

            e.type
            ==
            selectedType,

      ).toList();

    }

    switch (
        sort
    ) {

      case "Latest":

        tx.sort(

          (a, b)

              =>

              b.date.compareTo(
                a.date,
              ),

        );

        break;

      case "Oldest":

        tx.sort(

          (a, b)

              =>

              a.date.compareTo(
                b.date,
              ),

        );

        break;

      case "Highest":

        tx.sort(

          (a, b)

              =>

              b.amount.compareTo(
                a.amount,
              ),

        );

        break;

      case "Lowest":

        tx.sort(

          (a, b)

              =>

              a.amount.compareTo(
                b.amount,
              ),

        );

    }

    return tx;

  }

  Widget filterChip(
    String value,
    String current,
    Function(String)
        update,
  ) {

    return Padding(

      padding:

          const EdgeInsets.only(
        right:
            8,
      ),

      child:

          ChoiceChip(

        label:
            Text(
          value,
        ),

        selected:
            value
            ==
            current,

        onSelected:

            (_) {

          update(
            value,
          );

          setState(
            () {},
          );

        },

      ),

    );

  }

  @override
  Widget build(
      BuildContext context) {

    final transactions =
        filtered();

    final years = [

      "All",

      ...AppData
          .transactions
          .map(

            (e)

                =>

                e.date.year
                    .toString(),

          )

          .toSet(),

    ];

final categories = [

"All",

...AppData.transactions

.map(

(e)=>

e.category,

)

.toSet(),

];

    final accounts = [

      "All",

      ...AppData
          .transactions
          .map(

            (e)

                =>

                e.account,

          )

          .toSet(),

    ];

    return Scaffold(

      appBar:

          AppBar(

        title:

            const Text(
          "Transactions",
        ),

      ),

      body:

          Column(

        children: [

          SingleChildScrollView(

            scrollDirection:
                Axis.horizontal,

            child:

                Row(

              children: [

                filterChip(
                  "All",
                  selectedType,
                  (
                    v,
                  ) {
                    selectedType =
                        "All";
                  },
                ),

                filterChip(
                  "Income",
                  selectedType,
                  (
                    v,
                  ) {
                    selectedType =
                        v;
                  },
                ),

                filterChip(
                  "Expense",
                  selectedType,
                  (
                    v,
                  ) {
                    selectedType =
                        v;
                  },
                ),

                filterChip(
                  "Transfer",
                  selectedType,
                  (
                    v,
                  ) {
                    selectedType =
                        v;
                  },
                ),

              ],

            ),

          ),

          Padding(

            padding:

                const EdgeInsets
                    .all(
              8,
            ),

            child:

                Column(

children: [

Row(

children: [

Expanded(

child:

DropdownButtonFormField(
isExpanded:
true,
decoration:

const InputDecoration(

labelText:
"Year",

border:
OutlineInputBorder(),

),

value:
selectedYear,

items:

years

.map(

(e)

=>

DropdownMenuItem(

value:
e,

child:

Text(
e,
),

),

)

.toList(),

onChanged:

(v){

setState(() {

selectedYear =
v!;

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

DropdownButtonFormField(
isExpanded:
true,
decoration:

const InputDecoration(

labelText:
"Month",

border:
OutlineInputBorder(),

),

value:
selectedMonth,

items:

months

.map(

(e)

=>

DropdownMenuItem(

value:
e,

child:

Text(
e,
),

),

)

.toList(),

onChanged:

(v){

setState(() {

selectedMonth =
v!;

});

},

),

),

],

),

const SizedBox(
height:
10,
),

Row(

children:[

Expanded(

child:

DropdownButtonFormField(
isExpanded:
true,
decoration:

const InputDecoration(

labelText:
"Account",

border:
OutlineInputBorder(),

),

value:
selectedAccount,

items:

accounts

.map(

(e)

=>

DropdownMenuItem(

value:
e,

child:

Text(
e,
),

),

)

.toList(),

onChanged:

(v){

setState(() {

selectedAccount =
v!;

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

DropdownButtonFormField(
isExpanded:
true,
decoration:

const InputDecoration(

labelText:
"Category",

border:
OutlineInputBorder(),

),

value:
selectedCategory,

items:

categories

.map(

(e)

=>

DropdownMenuItem(

value:
e,

child:

Text(
e,
),

),

)

.toList(),

onChanged:

(v){

setState(() {

selectedCategory =
v!;

});

},

),

),

],

),

const SizedBox(
height:
10,
),

DropdownButtonFormField(
isExpanded:
true,
decoration:

const InputDecoration(

labelText:
"Sort",

border:
OutlineInputBorder(),

),

value:
sort,

items:

[

"Latest",

"Oldest",

"Highest",

"Lowest",

]

.map(

(e)

=>

DropdownMenuItem(

value:
e,

child:

Text(
e,
),

),

)

.toList(),

onChanged:

(v){

setState(() {

sort =
v!;

});

},

),

],
),

          ),

          Expanded(

            child:

                transactions.isEmpty

                    ?

                    const Center(

                        child:

                            Text(

                      "No Transactions",

                    ))

                    :

                    ListView.builder(

                        itemCount:
                            transactions.length,

                        itemBuilder:

                            (
                          context,
                          index,
                        ) {

                          final tx =
                              transactions[index];

                          return Card(

                            child:

                                ListTile(

                              onTap:

                                  () {

                                openEdit(

                                  AppData
                                      .transactions
                                      .indexWhere(

                                    (e)

                                        =>

                                        e.id
                                        ==
                                        tx.id,

                                  ),

                                );

                              },

                              title:

                                  Text(

                                tx.description
                                        .trim()
                                        .isEmpty

                                    ?

                                    tx.category

                                    :

                                    tx.description,

                              ),

                              subtitle:

                                  Text(

                                "${tx.account}\n${tx.date.toString().split(" ")[0]}",

                              ),

                              trailing:

SizedBox(

width:
90,

child:

Column(

mainAxisAlignment:

MainAxisAlignment.center,

crossAxisAlignment:

CrossAxisAlignment.end,

children:[

FittedBox(

fit:

BoxFit.scaleDown,

child:

Text(

"${tx.type == "Income" ? "+" : "-"}${AppData.currency}${tx.amount}",

maxLines:
1,

),

),

const SizedBox(
height:
4,
),

Text(

tx.type,

overflow:

TextOverflow.ellipsis,

),

],

),

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