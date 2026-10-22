import 'package:flutter/material.dart';

import '../../models/transaction_model.dart';
import '../../services/app_data.dart';

class TransferScreen extends StatefulWidget {

  const TransferScreen({
    super.key,
  });

  @override
  State<TransferScreen> createState()

      =>

      _TransferScreenState();

}

class _TransferScreenState
    extends State<TransferScreen> {

  final amount =
      TextEditingController();

  final note =
      TextEditingController();

  late String from;

  late String to;

  @override
  void initState() {

    super.initState();

    from =
        AppData
            .accounts
            .first
            .name;

    to =
        AppData
            .accounts
            .last
            .name;

  }

  void transfer() {

    final value =

        double.tryParse(
              amount.text,
            )
            ??
            0;

    if (

      value
      <=
      0

    ) {

      return;

    }

    if (

      from
      ==
      to

    ) {

      return;

    }

    final source =

        AppData.accounts
            .firstWhere(

      (e)

          =>

          e.name
          ==
          from,

    );

    final target =

        AppData.accounts
            .firstWhere(

      (e)

          =>

          e.name
          ==
          to,

    );

    source.balance -=
        value;

    target.balance +=
        value;

    AppData.transactions.add(

      TransactionModel(

        id:

            DateTime
                .now()
                .millisecondsSinceEpoch
                .toString(),

        amount:
            value,

        type:
            "Transfer",

        category:
            "Transfer",

        description:
            note.text,

        account:
            from,

        transferTo:
            to,

        date:
            DateTime.now(),

      ),

    );

    AppData.save();

    Navigator.pop(
      context,
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
          "Transfer Money",
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

              value:
                  from,

              decoration:

                  const InputDecoration(

                labelText:
                    "From Account",

                border:
                    OutlineInputBorder(),

              ),

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

                  from =
                      v!;

                });

              },

            ),

            const SizedBox(
              height:
                  16,
            ),

            DropdownButtonFormField(

              value:
                  to,

              decoration:

                  const InputDecoration(

                labelText:
                    "To Account",

                border:
                    OutlineInputBorder(),

              ),

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

                  to =
                      v!;

                });

              },

            ),

            const SizedBox(
              height:
                  16,
            ),

            TextField(

              controller:
                  amount,

              keyboardType:
                  TextInputType
                      .number,

              decoration:

                  InputDecoration(

                labelText:
                    "Transfer Amount",

                border:
                    OutlineInputBorder(),

                prefixText:
                    "${AppData.currency} ",

              ),

            ),

            const SizedBox(
              height:
                  16,
            ),

            TextField(

              controller:
                  note,

              decoration:

                  const InputDecoration(

                labelText:
                    "Description (Optional)",

                border:
                    OutlineInputBorder(),

              ),

            ),

            const Spacer(),

            SizedBox(

              width:
                  double.infinity,

              child:

                  ElevatedButton.icon(

                icon:

                    const Icon(
                  Icons.swap_horiz,
                ),

                onPressed:
                    transfer,

                label:

                    const Text(
                  "Transfer",

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}