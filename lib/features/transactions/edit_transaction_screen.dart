import 'package:flutter/material.dart';

import '../../models/transaction_model.dart';
import '../../services/app_data.dart';

class EditTransactionScreen extends StatefulWidget {

  final TransactionModel transaction;

  const EditTransactionScreen({
    super.key,
    required this.transaction,
  });

  @override
  State<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();

}

class _EditTransactionScreenState
    extends State<EditTransactionScreen> {

  late TextEditingController amount;

  late TextEditingController description;

  late String type;

  late String category;

  late String account;

  late DateTime date;

  List get categories {

    return AppData.categories

        .where(
          (e) =>
              e.type ==
              type,
        )

        .toList();

  }

  @override
  void initState() {

    super.initState();

    amount = TextEditingController(
      text:
          widget.transaction.amount
              .toString(),
    );

    description = TextEditingController(
      text:
          widget.transaction.description,
    );

    type =
        widget.transaction.type;

    category =
        widget.transaction.category;

    account =
        widget.transaction.account;

    date =
        widget.transaction.date;

  }

  Future pickDate()
  async {

    final picked =
        await showDatePicker(

      context:
          context,

      initialDate:
          date,

      firstDate:
          DateTime(
              2020),

      lastDate:
          DateTime(
              2100),

    );

    if (

      picked
      !=
      null

    ) {

      setState(() {

        date =
            picked;

      });

    }

  }

  void reverse(
TransactionModel tx,
) {

if (

tx.transferTo
!=
null

) {

final from =

AppData.accounts
.firstWhere(

(e)=>

e.name
==
tx.account,

);

final to =

AppData.accounts
.firstWhere(

(e)=>

e.name
==
tx.transferTo,

);

from.balance +=
tx.amount;

to.balance -=
tx.amount;

return;

}

final acc =

AppData.accounts
.firstWhere(

(e)=>

e.name
==
tx.account,

);

if (

tx.type
==
"Income"

) {

acc.balance -=
tx.amount;

}

else if (

tx.type
==
"Expense"

) {

acc.balance +=
tx.amount;

}

}

  void apply(
TransactionModel tx,
) {

if (

tx.transferTo
!=
null

) {

final from =

AppData.accounts
.firstWhere(

(e)=>

e.name
==
tx.account,

);

final to =

AppData.accounts
.firstWhere(

(e)=>

e.name
==
tx.transferTo,

);

from.balance -=
tx.amount;

to.balance +=
tx.amount;

return;

}

final acc =

AppData.accounts
.firstWhere(

(e)=>

e.name
==
tx.account,

);

if (

tx.type
==
"Income"

) {

acc.balance +=
tx.amount;

}

else if (

tx.type
==
"Expense"

) {

acc.balance -=
tx.amount;

}

}

  void delete() {

    reverse(
      widget.transaction,
    );

    AppData.transactions
        .removeWhere(

      (e)

          =>

          e.id
          ==
          widget.transaction.id,

    );

    AppData.save();

    Navigator.pop(
      context,
      true,
    );

  }

  void save() {

    final index =

        AppData.transactions
            .indexWhere(

      (e)

          =>

          e.id
          ==
          widget.transaction.id,

    );

    if (
        index <
        0
    ) return;

    reverse(
      widget.transaction,
    );

    final updated =

        widget.transaction
            .copyWith(

      amount:

          double.tryParse(
                amount.text,
              )
              ??
              0,

      description:
          description.text,

      type:
          type,

      category:
          category,

      account:
          account,

      date:
          date,

    );

    apply(
      updated,
    );

    AppData.transactions[
        index] = updated;

    AppData.save();

    Navigator.pop(
      context,
      true,
    );

  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar:
          AppBar(

        title:

            const Text(
          "Edit Transaction",
        ),

        actions: [

          IconButton(

            icon:
                const Icon(
              Icons.delete,
            ),

            onPressed:
                delete,

          ),

        ],

      ),

      body:

          Padding(

        padding:

            const EdgeInsets
                .all(
          16,
        ),

        child:

            Column(

          children: [

            DropdownButtonFormField(

value:
type,

decoration:

const InputDecoration(

labelText:
"Type",

),

items:

[

"Income",

"Expense",

"Transfer",

]

.map(

(e)

=>

DropdownMenuItem<String>(

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

setState((){

type =
v as String;

});

},

),

            const SizedBox(
              height:
                  12,
            ),

            DropdownButtonFormField(

              value:
                  category,

              decoration:

                  const InputDecoration(
                labelText:
                    "Category",
              ),

              items:

                  categories

                      .map(

                        (e)

                            =>

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
                  (v) {

                setState(() {

                  category =
                      v as String;

                });

              },

            ),

            const SizedBox(
              height:
                  12,
            ),

            DropdownButtonFormField(

              value:
                  account,

              decoration:

                  const InputDecoration(
                labelText:
                    "Account",
              ),

              items:

                  AppData.accounts

                      .map(

                        (e)

                            =>

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
                  (v) {

                setState(() {

                  account =
                      v as String;

                });

              },

            ),

            const SizedBox(
              height:
                  12,
            ),

            TextField(

              controller:
                  amount,

              decoration:

                  const InputDecoration(
                labelText:
                    "Amount",
              ),

            ),

            const SizedBox(
              height:
                  12,
            ),

            TextField(

              controller:
                  description,

              decoration:

                  const InputDecoration(
                labelText:
                    "Description",
              ),

            ),

            const SizedBox(
              height:
                  12,
            ),

            ListTile(

              title:

                  Text(

                date
                    .toString()
                    .split(
                        " ")[0],

              ),

              trailing:

                  const Icon(
                Icons.calendar_month,
              ),

              onTap:
                  pickDate,

            ),

            const Spacer(),

            SizedBox(

              width:
                  double.infinity,

              child:

                  ElevatedButton(

                onPressed:
                    save,

                child:

                    const Text(
                  "Save",
                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}