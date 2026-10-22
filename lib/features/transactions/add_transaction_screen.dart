import 'package:flutter/material.dart';

import '../../models/transaction_model.dart';
import '../../services/app_data.dart';
import '../categories/category_screen.dart';

class AddTransactionScreen extends StatefulWidget {

  const AddTransactionScreen({
    super.key,
  });

  @override
  State<AddTransactionScreen>
      createState()

          =>

          _AddTransactionScreenState();

}

class _AddTransactionScreenState
    extends State<
        AddTransactionScreen> {

  final amountController =
      TextEditingController();

  final descriptionController =
      TextEditingController();

  String transactionType =
      "Expense";

  DateTime selectedDate =
      DateTime.now();

  late String selectedAccount;

  late String category;

  @override
  void initState() {

    super.initState();

    selectedAccount =
        AppData
            .accounts
            .first
            .name;

    category =
        categories
            .first
            .name;

  }

  List get categories {

    return AppData
        .categories
        .where(

          (e)

              =>

              e.type
              ==
              transactionType,

        )

        .toList();

  }

  void save() {

    final amount =

        double.tryParse(

              amountController
                  .text,

            )

            ??

            0;

    final selected =

        AppData
            .accounts
            .firstWhere(

      (e)

          =>

          e.name
          ==
          selectedAccount,

    );

    if (

      transactionType
      ==
      "Income"

    ) {

      selected.balance +=
          amount;

    }

    else {

      selected.balance -=
          amount;

    }

    AppData.transactions.add(

      TransactionModel(

        id:

            DateTime
                .now()
                .microsecondsSinceEpoch
                .toString(),

        amount:
            amount,

        type:
            transactionType,

        category:
            category,

        description:

            descriptionController
                .text,

        account:
            selectedAccount,

        date:
            selectedDate,

      ),

    );

    AppData.save();

    Navigator.pop(
      context,
    );

  }

  Future pickDate()
  async {

    final picked =

        await showDatePicker(

      context:
          context,

      initialDate:
          selectedDate,

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

        selectedDate =
            picked;

      });

    }

  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar:

          AppBar(

        title:

            const Text(
          "Add Transaction",
        ),

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

              decoration:

                  const InputDecoration(

                labelText:
                    "Type",

              ),

              value:
                  transactionType,

              items:

                  [

                "Expense",

                "Income",

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

                  (v) {

                setState(() {

                  transactionType =
                      v as String;

                  category =

                      categories
                          .first
                          .name;

                });

              },

            ),

            const SizedBox(
              height:
                  10,
            ),

            Row(

              children: [

                Expanded(

                  child:

                      DropdownButtonFormField(

                    decoration:

                        const InputDecoration(

                      labelText:
                          "Category",

                    ),

                    value:
                        category,

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

                ),

                IconButton(

                  icon:

                      const Icon(
                    Icons.add,
                  ),

                  onPressed:
                      () async {

                    await Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder:

                            (_)

                                =>

                                const CategoryScreen(),

                      ),

                    );

                    setState(() {

                      category =

                          categories
                              .first
                              .name;

                    });

                  },

                ),

              ],

            ),

            const SizedBox(
              height:
                  10,
            ),

            TextField(

              controller:
                  amountController,

              keyboardType:
                  TextInputType
                      .number,

              decoration:

                  const InputDecoration(

                labelText:
                    "Amount",

              ),

            ),

            const SizedBox(
              height:
                  10,
            ),

            TextField(

              controller:
                  descriptionController,

              decoration:

                  const InputDecoration(

                labelText:
                    "Description",

              ),

            ),

            const SizedBox(
              height:
                  10,
            ),

            DropdownButtonFormField(

              decoration:

                  const InputDecoration(

                labelText:
                    "Account",

              ),

              value:
                  selectedAccount,

              items:

                  AppData
                      .accounts

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

                  selectedAccount =
                      v as String;

                });

              },

            ),

            ListTile(

              title:

                  Text(

                selectedDate
                    .toString()
                    .split(
                      " ",
                    )[0],

              ),

              subtitle:

                  const Text(
                "Date",
              ),

              trailing:

                  const Icon(
                Icons.date_range,
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